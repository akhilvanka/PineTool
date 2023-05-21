//
//  TemperatureLargeView.swift
//  PineTool
//
//  Created by Akhil Vanka on 5/21/23.
//  Copyright © 2023 Srinivasa Vanka. All rights reserved.
//

import SwiftUI

struct TemperatureLargeView: View {
    
    @EnvironmentObject var pinecilManager: PinecilManager
    
    @State private var presentingPeripheralList = false
    @State private var presentingSettings = false
    @State private var viewController: UIViewController?
    
    @State var celcius = true
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    var setPoint: some View {
        HStack(alignment: .center) {
            Button {
                viewController?.present(
                    TemperatureSetViewController(
                        temperature: pinecilManager.bulkData?.setpoint,
                        setCallback: {
                            pinecilManager.writeSetpoint($0)
                        },
                        validateCallback: { value in
                            guard let maxTemp = pinecilManager.bulkData?.maxTemperature else {
                                return false
                            }
                            guard value >= 50 else { return false }
                            return value <= maxTemp
                        }
                    ),
                    animated: true
                )
            } label: {
                Text("\(pinecilManager.bulkData?.setpoint ?? 320)°") //℃
                    .font(.system(size: UIScreen.screenWidth/2.5)).monospacedDigit()
                    .padding([.leading, .bottom, .trailing])
                    .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
            }
            .disabled(pinecilManager.bulkData?.setpoint == nil)
        }
    }
    
    
    @ViewBuilder
    var bottomInfo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.backgroundColor)
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    VStack(alignment: .center) {
                        Text("\(Double(pinecilManager.bulkData?.handleTemperature ?? 0) / 10.0, specifier: "%.1f") ℃")
                            .font(.title2).monospacedDigit()
                            .bold()

                        Text("Handle Temperature")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    VStack(alignment: .center) {
                        Text("\(Double(pinecilManager.bulkData?.estimatedWattage ?? 0) / 10.0, specifier: "%.1f") W")
                            .font(.title2).monospacedDigit()
                            .bold()

                        Text("Power")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            }
        }
    }
    
    @ViewBuilder
    var topConnection: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                Button {
                    if pinecilManager.state == .disconnected || pinecilManager.state == .scanning {
                        pinecilManager.scan()
                        presentingPeripheralList = true
                    } else {
                        pinecilManager.disconnect()
                    }
                } label: {
                    Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                        .font(.title)
                        .padding(.all)
                }
                Spacer()
                Button {
                    presentingSettings = true
                } label: {
                    Image(systemName: "gear")
                        .font(.title2)
                        .padding(.all)
                }
            }
            .padding([.top, .leading, .trailing])
        }
    }
    
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                topConnection
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(colorScheme == .dark ? Color.darkBlack : Color.white)
                    .frame(width:UIScreen.screenWidth, height: UIScreen.screenHeight-80)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top) {
                            Label("\(Double(pinecilManager.bulkData?.inputVoltage ?? 0) / 10.0, specifier: "%.1f") V", systemImage: "cable.connector.horizontal")
                                .font(.title3)
                                .bold()
                                .padding(.all)
                            Spacer()
                            Label("\(PowerSource(rawValue: pinecilManager.bulkData?.powerSource ?? .max)?.description ?? "Unknown")", systemImage: "poweroutlet.type.b.fill")
                                .font(.title3)
                                .bold()
                                .padding(.all)
                        }
                        Text("\(pinecilManager.bulkData?.tipTemperature ?? 0)°")
                            .font(.system(size: UIScreen.screenWidth/2.5))
                            .padding(.horizontal)
                        setPoint
                        bottomInfo
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $presentingPeripheralList) {
            DiscoveredPeripheralsList()
        }
        .sheet(isPresented: $presentingSettings) {
            SettingsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .introspectViewController { viewController in
            // Introspecting and storing the host view controller like this
            // is hacky, but unfortunately SwiftUI doesn't have the
            // capability to present a `UIViewControllerRepresentable` with
            // a custom transition.
            self.viewController = viewController
        }
    }
}

struct TemperatureLargeView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureLargeView()
            .environmentObject(PinecilManager())
    }
}
