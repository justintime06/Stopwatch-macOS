//
//  ContentView.swift
//  Stopwatch
//
//  Created by Epstein Apps on 4/17/22.
//

import SwiftUI

var pressedColor = Color(red: 13/255, green: 29/255, blue: 14/255)
var unpressedColor = Color(red: 19/255, green: 41/255, blue: 20/255)
var startStopColor = Color(red: 104/255, green: 205/255, blue: 103/255)

struct Lap: Hashable, Codable {
    var lapName: String
    var lapTime: String
}

struct ContentView: View {
    
    @State var seconds : Int = 0
    @State var milliseconds : Int = 0
    @State var activeTimer = "00:00."
    @State var activemsTimer = "00"
    @State var startStopText = "Start"
    @State var lapRestartText = "Lap"
    @State var activelyCounting = false
    @State var lapRestartOpacity = 0.5
    @State var laps = [Lap]()
    @State var lapCounter = 1
    @State var firstLap = "00:00.00"
    @State var isFirstLap = true
    @State var lapseconds : Int = 0
    @State var lapmilliseconds : Int = 0
    @State var lapactiveTimer = "00:00."
    @State var lapactivemsTimer = "00"
    @State var lapactivelyCounting = false
    @State var emptyOrWhite : Color = .black
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("\(activeTimer)\(activemsTimer)")
                .font(Font.system(size: 75, weight: .thin).monospacedDigit())
                .foregroundColor(.white)
                .frame(width: 326, height: 70, alignment: .center)
            Spacer()
            HStack {
                // Lap/Reset Button
                Button(action: {
                    print("Lap clicked")
                    if lapRestartText == "Reset" {
                        seconds = 0
                        milliseconds = 0
                        activeTimer = "00:00."
                        activemsTimer = "00"
                        lapRestartText = "Lap"
                        lapRestartOpacity = 0.5
                        lapCounter = 1
                        laps = []
                        emptyOrWhite = .black
                        laps.append(Lap(lapName: "⠀", lapTime: ""))
                        laps.append(Lap(lapName: "⠀", lapTime: ""))
                        laps.append(Lap(lapName: "⠀", lapTime: ""))
                        laps.append(Lap(lapName: "⠀", lapTime: ""))
                        isFirstLap = true
                    }
                    if lapRestartText == "Lap" && (milliseconds > 0 || seconds > 0) {
                        lapCounter += 1
                        // Create new lap with blank time
                        laps.insert(Lap(lapName: "Lap \(lapCounter)", lapTime: ""), at: 0)
                        lapseconds = 0
                        lapmilliseconds = 0
                        lapactiveTimer = "00:00."
                        lapactivemsTimer = "00"
                        isFirstLap = false
                        //x = 0
                        print(lapCounter)
                        if lapCounter == 2 {
                            laps.removeLast()
                        }
                        if lapCounter == 3 {
                            laps.removeLast()
                        }
                        if lapCounter == 4 {
                            laps.removeLast()
                        }
                    }
                }) {
                    Text("\(lapRestartText)")
                }
                .buttonStyle(LapRestartCircleButtonStyle())
                .opacity(lapRestartOpacity)
                .padding(.leading, 25)
                Spacer()
                // Start Button
                Button(action: {
                    var msTimer: Timer?
                    print (msTimer ?? "msTimer starting...")
                    msTimer =  Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (msTimer) in
                        activelyCounting = true
                        milliseconds += 1
                        activemsTimer = String(format:"%02i", milliseconds)
                        lapmilliseconds += 1
                        lapactivemsTimer = String(format:"%02i", lapmilliseconds)
                        if milliseconds == 100 {
                            seconds += 1
                            activeTimer = timeString(time: TimeInterval(seconds))
                            milliseconds = 0
                            activemsTimer = "00"
                        }
                        if lapmilliseconds == 100 {
                            lapseconds += 1
                            lapactiveTimer = timeString(time: TimeInterval(lapseconds))
                            lapmilliseconds = 0
                            lapactivemsTimer = "00"
                        }
                        if startStopText == "Start" {
                            msTimer.invalidate()
                            activelyCounting = false
                        }
                        if isFirstLap == true {
                            laps = [Lap(lapName: "Lap 1", lapTime: "\(activeTimer)\(activemsTimer)")]
                            emptyOrWhite = .white
                            laps.append(Lap(lapName: "⠀", lapTime: ""))
                            laps.append(Lap(lapName: "⠀", lapTime: ""))
                            laps.append(Lap(lapName: "⠀", lapTime: ""))
                        } else {
                            laps[0] = Lap(lapName: "Lap \(lapCounter)", lapTime: "\(lapactiveTimer)\(lapactivemsTimer)")
                        }
                    }
                    if startStopText == "Start" {
                        startStopText = "Stop"
                        pressedColor = Color(red: 33/255, green: 11/255, blue: 9/255)
                        unpressedColor = Color(red: 47/255, green: 16/255, blue: 13/255)
                        startStopColor = Color(red: 230/255, green: 83/255, blue: 68/255)
                        lapRestartOpacity = 1.0
                        //emptyOrWhite = .white
                    } else if startStopText == "Stop" {
                        startStopText = "Start"
                        pressedColor = Color(red: 13/255, green: 29/255, blue: 14/255)
                        unpressedColor = Color(red: 19/255, green: 41/255, blue: 20/255)
                        startStopColor = Color(red: 104/255, green: 205/255, blue: 103/255)
                        //emptyOrWhite = .white
                        msTimer?.invalidate()
                        print("stopping timers")
                    }
                    if activelyCounting == true {
                        lapRestartText = "Reset"
                    } else {
                        lapRestartText = "Lap"
                    }
                }) {
                    Text("\(startStopText)")
                }
                .buttonStyle(BlueCircleButtonStyle())
                .padding(.trailing, 25)
            }
            .padding(.bottom)
            ScrollView(.vertical, showsIndicators: false) {
                Divider()
                    .background(Color(red: 51/255, green: 50/255, blue: 53/255))
                    .padding(.horizontal)
                ForEach(laps, id: \.self) { lap in
                    VStack {
                        HStack {
                            Text(lap.lapName)
                                .foregroundColor(.white)
                                .font(Font.system(size: 15))
                            Spacer()
                            Text(lap.lapTime)
                                .foregroundColor(.white)
                                .font(Font.system(size: 15).monospacedDigit())
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .listRowBackground(Color.black)
                        Divider()
                            .background(Color(red: 51/255, green: 50/255, blue: 53/255))
                            .padding(.horizontal)
                    }
                }
            }
            .frame(width: 750/2.3, height: 150, alignment: .center)
            .onAppear(perform: {
                laps.append(Lap(lapName: "⠀", lapTime: ""))
                laps.append(Lap(lapName: "⠀", lapTime: ""))
                laps.append(Lap(lapName: "⠀", lapTime: ""))
                laps.append(Lap(lapName: "⠀", lapTime: ""))
            })
        }
        .frame(minWidth: 750/2.3, idealWidth: 750/2.3, maxWidth: 750/2.3, minHeight: 1334/2.3, idealHeight: 1334/2.3, maxHeight: 1334/2.3, alignment: .center)
        .background(Color(red: 0, green: 0, blue: 0, opacity: 1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func timeString(time:TimeInterval) -> String {
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i.", minutes, seconds)
}

func mstimeString(time:TimeInterval) -> String {
    let milliseconds = Int(time) % 60
    return String(format:"%02i", milliseconds)
}

struct LapRestartCircleButtonStyle: ButtonStyle {
    var pressedColor2 = Color(red: 31/255, green: 31/255, blue: 31/255)
    var unpressedColor2 = Color(red: 51/255, green: 51/255, blue: 51/255)
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.padding().modifier(MakeSquareBounds())
            .background(
                Circle()
                    .fill(configuration.isPressed ? pressedColor2 : unpressedColor2)
                    .background(
                        Circle()
                            .fill(Color.black)
                            .frame(width: 70, height: 69, alignment: .center)
                    )
                    .background(
                        Circle()
                            .fill(configuration.isPressed ? pressedColor2 : unpressedColor2)
                            .frame(width: 74, height: 73, alignment: .center)
                    )
            )
            .foregroundColor(.white)
    }
}

struct BlueCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.padding().modifier(MakeSquareBounds())
            .background(
                Circle()
                    .fill(configuration.isPressed ? pressedColor : unpressedColor)
                    .background(
                        Circle()
                            .fill(Color.black)
                            .frame(width: 70, height: 69, alignment: .center)
                    )
                    .background(
                        Circle()
                            .fill(configuration.isPressed ? pressedColor : unpressedColor)
                            .frame(width: 74, height: 73, alignment: .center)
                    )
            )
            .foregroundColor(startStopColor)
    }
}

struct MakeSquareBounds: ViewModifier {
    @State var size: CGFloat = 1000
    func body(content: Content) -> some View {
        let c = ZStack {
            content.alignmentGuide(HorizontalAlignment.center) { (vd) -> CGFloat in
                DispatchQueue.main.async {
                    self.size = max(vd.height, vd.width)
                }
                return vd[HorizontalAlignment.center]
            }
        }
        return c.frame(width: 70, height: 65)
    }
}
