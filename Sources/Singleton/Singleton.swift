//
//  Singleton.swift
//  Singleton
//
//  Created by NullSilck on 2026/10/14.
//

@attached(member, names: named(shared), named(init))
public macro Singleton() = #externalMacro(module: "SingletonMacros", type: "SingletonMacro")
