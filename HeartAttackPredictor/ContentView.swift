//
//  ContentView.swift
//  HeartAttackPredictor
//
//  Created by Adarsh Singh on 05/11/23.
//

import SwiftUI
import CoreML
struct ContentView: View {
    @State private var age = 1
    @State private var sex = "Male"
    @State private var cholestrol = 0
    @State private var bp = "150/88"
    @State private var heartRate = 72
    @State private var diabates = 0
    @State private var smoking = 0
    @State private var obesity = 0
    @State private var Ac = 0
    @State private var diet = "Healthy"
    @State private var prevHeartProblem = 0
    @State private var stressLevel = 0
    @State private var physicalActivityDaysPerWeek = 0
    @State private var sleepHrs = 6
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    
                        Text("Enter Details")
                            .font(.headline)
                    Picker("Age", selection: $age){
                        ForEach(1...100, id: \.self){
                            number in
                            Text("\(number)")
                        }
                    }
                            
                        Picker("Sex",selection: $sex){
                            Text("Male")
                                .tag("Male")
                            Text("Female")
                                .tag("Female")
                            
                        }.pickerStyle(.menu)
                            
                        
                    
                }
                Section{
                    VStack{
                        HStack{
                            Text("Cholestrol")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Cholestrol", value: $cholestrol, format: .number)
                                
                        }
                        
                            
                    }
                    VStack{
                        HStack{
                            Text("Blood Pressure")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Bp", text: $bp)
                                
                        }
                        
                            
                    }
                    VStack{
                        HStack{
                            Text("Heart Rate")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("heart rate", value: $heartRate, format: .number)
                                
                        }
                        
                            
                    }
                    Picker("Diabates",selection: $diabates){
                        Text("Yes")
                            .tag(1)
                        Text("No")
                            .tag(0)
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Smoking",selection: $smoking){
                        Text("Yes")
                            .tag(1)
                        Text("No")
                            .tag(0)
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Obesity",selection: $obesity){
                        Text("Yes")
                            .tag(1)
                        Text("No")
                            .tag(0)
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Alcohol Consumption",selection: $Ac){
                        Text("Yes")
                            .tag(1)
                        Text("No")
                            .tag(0)
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                }
                Section{
                    Picker("Diet",selection: $diet){
                        Text("Healthy")
                            .tag("Healthy")
                        Text("Unhealthy")
                            .tag("Unhealthy")
                        Text("Average")
                            .tag("Average")
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Previous Heart Problem",selection: $prevHeartProblem){
                        Text("Yes")
                            .tag(1)
                        Text("No")
                            .tag(0)
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Stress Level",selection: $stressLevel){
                        ForEach(0...10,id:\.self){
                            number in
                            Text("\(number)")
                        }
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Physical Activity Days/Week",selection: $physicalActivityDaysPerWeek){
                        ForEach(0...7,id:\.self){
                            number in
                            Text("\(number)")
                        }
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    Picker("Sleep Hours",selection: $sleepHrs){
                        ForEach(1...12,id:\.self){
                            number in
                            Text("\(number)")
                        }
                        
                    }.pickerStyle(.menu)
                        .font(.headline)
                    
                }
                
            }.navigationTitle("Personal Details")
                .onAppear()
                .toolbar{
                    Button("Predict", action: heartAttackPredict)
                }
                .alert(alertTitle, isPresented: $showingAlert){
                    Button("OK"){}
                    
                }message: {
                    Text(alertMessage)
                }
            
            
        }
        
    }
    func heartAttackPredict(){
        do {
            let config = MLModelConfiguration()
            let model  = try HeartAttackPrediction(configuration: config)
            
            let prediction = try model.prediction(Age: Int64(age), Sex: sex, Cholesterol: Int64(cholestrol), Blood_Pressure: bp, Heart_Rate: Int64(heartRate), Diabetes: Int64(diabates), Smoking: Int64(smoking), Obesity: Int64(obesity), Alcohol_Consumption: Int64(Ac), Diet: diet, Previous_Heart_Problems: Int64(prevHeartProblem), Stress_Level: Int64(stressLevel), Physical_Activity_Days_Per_Week: Int64(physicalActivityDaysPerWeek), Sleep_Hours_Per_Day: Int64(sleepHrs))
            
            let risk = prediction.Heart_Attack_Risk
            print(risk)
            alertTitle = "Heart Attack Risk..."
            if risk < 0.300 && risk > 0.100{
                alertMessage = "Slight risk"
            }
            else if risk < 0.600 && risk > 0.300{
                alertMessage = "High Risk!"
            }
            else if risk < 1.00 && risk > 0.600{
                alertMessage = "Very High Risk! Consult Doctor!"
            }
            else if risk < 0.100{
                alertMessage = "All Good! Keep it up"
            }
        }catch{
            alertTitle = "Error"
            alertMessage = "Sorry, There was an error in predicting."
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
