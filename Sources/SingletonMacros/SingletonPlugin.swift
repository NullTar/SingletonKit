//
//  SingletonPlugin.swift
//  Singleton
//
//  Created by NullSilck on 2026/10/14.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SingletonPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SingletonMacro.self
    ]
}
