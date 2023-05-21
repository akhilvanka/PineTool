//
//  SettingsView.swift
//  PineTool
//
//  Created by Lachlan Bell on 22/4/2023.
//  Copyright © 2023 Lachlan Bell. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("keep-awake") var keepAwake = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Keep Display Awake", isOn: $keepAwake)
                        .tint(.accentColor)
                }

                Section {
                    Link(
                        "Twitter",
                        destination: URL(string: "https://twitter.com/lachyio")!
                    )

                    Link(
                        "Source Code",
                        destination: URL(string: "https://github.com/lachlanbell/PineTool")!
                    )

                    Link(
                        "Troubleshooting",
                        destination: URL(string: "https://lachy.io/pinetool/help")!
                    )

                    Link(
                        "Privacy Policy",
                        destination: URL(string: "https://lachy.io/pinetool/privacy")!
                    )
                }
                .tint(.primary)
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
    }
}

struct SettingsView_previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PinecilManager())
    }
}
