//
//  PlaneOnMapView.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import SwiftUI
import Combine
import MapKit
import NeedleFoundation

struct PlaneOnMapView: View {
    enum Constants {
        static let mapAnnotationImageName = UIImage(named: "map_airpane")!
        
        enum Timer {
            static let repeatInterval = 10.0
        }
        
        enum Size {
            static let activityIndicatorCornerRadius = 10.0
            static let activityIndicatorShadowRadius = 10.0
            static let annotationImageHeight = 50.0
            static let annotationimageWidth = 50.0
            static let plainsListEdgeInsets = EdgeInsets(top: 20.0, leading: 20.0, bottom: 20.0, trailing: 20.0)
            static let plainsButtonCornerRadius = 18.0
            static let plainsLineWidth = 2.0
        }
        
        enum Fonts {
            static let plainsListFont = Font.system(size: 18.0, weight: .regular)
        }
        
        enum Description {
            static let plainsList = "Plain's list"
            static let alertError = "ERROR"
            static let alertMessage = "SOMETHING GET WRONG"
            static let alertOkText = "Ok"
            static let mapAnnotationImageName = "map_airpane"
            static let errorMessage = "Something get wrong"
        }
        
        enum Colors {
            static let annotationForegroundColor = Color.purple
        }
    }
    
    @State private var region = MKCoordinateRegion.getCzechRegion()
    @State private var timer = Timer.publish(every: Constants.Timer.repeatInterval, on: .main, in: .common).autoconnect()

    @StateObject var viewModel: PlaneOnMapViewModel
    
    var body: some View {
        VStack {
            ZStack {
                makeMap()
                makeProgressView()
            }
            makeMoveToPlainsListButton()
        }
        .alert(isPresented: $viewModel.shouldShowEnableBiometricPrompt) {
            Alert(title: Text(Constants.Description.alertError),
                  message: Text(Constants.Description.alertMessage),
                  primaryButton: .default(Text(Constants.Description.alertOkText), action: {
            }), secondaryButton: .cancel())
        }
        .onAppear {
            viewModel.getAirplanePositions.send(true)
        }
        .onReceive(timer) { newTime in
            viewModel.getAirplanePositions.send(true)
        }
    }
    
    private func makeMoveToPlainsListButton() -> some View {
        Button(action: {
        }) {
            NavigationLink(destination: PlanesListView(airplanePositions: $viewModel.airplanePositions)) {
                Text(Constants.Description.plainsList)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .font(Constants.Fonts.plainsListFont)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.Size.plainsButtonCornerRadius)
                            .stroke(Color.white,
                                    lineWidth: Constants.Size.plainsLineWidth)
                    )
            }
          }
          .background(Color.red)
          .cornerRadius(Constants.Size.plainsButtonCornerRadius)
          .padding(Constants.Size.plainsListEdgeInsets)
    }
    
    private func makeMap() -> some View {
        Map(coordinateRegion: $region,
            annotationItems: viewModel.airplanePositions) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                Image(uiImage: Constants.mapAnnotationImageName)
                    .resizable()
                    .frame(width: Constants.Size.annotationimageWidth,
                           height: Constants.Size.annotationImageHeight)
                    .foregroundColor(Constants.Colors.annotationForegroundColor)
                    .rotationEffect(.degrees(annotation.trueTrack))
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    private func makeProgressView() -> some View {
        ProgressView()
            .padding()
            .background(Color.white)
            .cornerRadius(Constants.Size.activityIndicatorCornerRadius)
            .shadow(radius: Constants.Size.activityIndicatorShadowRadius)
            .isHidden(!viewModel.isLoading)
    }
}

struct PlaneOnMapView_Previews: PreviewProvider {
    static var previews: some View {
        PlaneOnMapView(viewModel:
                                PlaneOnMapViewModel(
                                    airplaneRequestDomain: PlaneRepository(),
                                    domainModel: PlaneDomainModel(airplanePositionsRepository: PlaneRepository()))
        )
    }
}
