//
//  ContentView.swift
//  Calculator
//
//  Created by Sphinx04 on 07.08.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = Calculator()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(model.text)")
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                        .padding(.all, 5)
                        .textFieldStyle(.plain)
                        .font(Font.system(size: 60, design: .default))
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                }
                Grid(alignment: .bottom) {
                    ForEach(model.buttons, id: \.self) { row in
                        GridRow {
                            ForEach(row, id: \.self) { button in
                                CButton(calcButton: button) {
                                    model.didTap(button: button)
                                    }
                            }
                        } //GRIDROW
                    }
                } //GRID
            } //VSTACK
            .padding()
        } //ZSTACK
    }
}

struct CButton: View {
    var calcButton: CalcButton
    @State var tapped = false
    var action: () -> Void

    var body: some View {

        let view = RoundedRectangle(cornerRadius: .infinity)
            .cornerRadius(.infinity)
            .foregroundColor(calcButton.buttonColor)
            .overlay {
                Text(calcButton.rawValue)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .overlay {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundColor(.white.opacity(tapped ? 0.3 : 0.0))
            }
            .onTapGesture {
                action()
                tapped = true
                withAnimation(.easeIn(duration: 0.3)) {
                    tapped = false
                }
            }
        if calcButton == .zero {
            view.gridCellUnsizedAxes(.vertical)
                .gridCellColumns(2)
                .aspectRatio(2, contentMode: .fit)
        } else {
            view
                .gridCellColumns(1)
                .aspectRatio(1, contentMode: .fit)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
