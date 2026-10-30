//
//  SingletonMacro.swift
//  Singleton
//
//  Created by NullSilck on 2026/10/14.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

//  不是 class：仍然报告原有的编译错误
//  没有显式 init：自动生成 static let shared 和 private init() {}
//  存在其他 init，但没有 private init()：发出编译警告，提醒用户自行定义
//  已经定义 private init()：不发出警告
public struct SingletonMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 检查是否为 class
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: SingletonDiagnostic.onlyClass))
            return []
        }

        let className = classDecl.name.text

        let shared: DeclSyntax =
            """
            static let shared = \(raw: className)()
            """

        // 获取当前 class 中声明的所有初始化器
        let initializers = classDecl.memberBlock.members.compactMap {
            $0.decl.as(InitializerDeclSyntax.self)
        }

        // 如果已经声明了初始化器，则检查是否存在 private init()
        if !initializers.isEmpty {
            let hasPrivateNoArgumentInitializer = initializers.contains { initializer in
                // 检查访问控制是否为 private
                let isPrivate = initializer.modifiers.contains {
                    $0.name.text == "private"
                }
                // 检查是否没有参数
                let hasNoArguments = initializer.signature.parameterClause.parameters.isEmpty
                return isPrivate && hasNoArguments
            }
            // 有其他初始化器，但没有 private init()，发出警告
            if !hasPrivateNoArgumentInitializer {
                context.diagnose(Diagnostic(node: Syntax(node), message: SingletonDiagnostic.mustHasPrivateInit))
            }
            return [shared]
        }

        let initializer: DeclSyntax =
            """
            private init() {}
            """
        return [shared, initializer]
    }
}

private enum SingletonDiagnostic: DiagnosticMessage {
    case onlyClass, mustHasPrivateInit

    var message: String {
        switch self {
        case .onlyClass:
            return "@Singleton can only be applied to a class."
        case .mustHasPrivateInit:
            return """
            @Singleton requires a private init(). \
            Please define a private init() yourself.
            """
        }
    }

    var diagnosticID: MessageID {
        switch self {
        case .onlyClass: MessageID(domain: "SingletonMacro", id: "onlyClass")
        case .mustHasPrivateInit: MessageID(domain: "SingletonMacro", id: "mustHasPrivateInit")
        }
    }

    var severity: DiagnosticSeverity {
        switch self {
        case .onlyClass:
            return .error
        case .mustHasPrivateInit:
            return .warning
        }
    }
}
