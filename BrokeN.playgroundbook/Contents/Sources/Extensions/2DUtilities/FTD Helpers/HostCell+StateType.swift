//
//  StateType.swift
//  FunctionalTableDataMyDemo
//
//  Created by Paige Sun on 2017-12-19.
//

import Foundation

protocol StateType {
    associatedtype View
    static func updateView(_ view: View, state: Self?)
}

extension HostCell where State: StateType, State.View == View {
    init(key: String, style: CellStyle? = nil, actions: CellActions = CellActions(), state: State) {
        self.key = key
        self.style = style
        self.actions = actions
        self.state = state
        self.cellUpdater = State.updateView
    }
}
