//
//  CoreImageBasicFiltersView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 07.03.23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CoreImageBasicFiltersView: View {
    
    @State private var image: Image?
    @State private var filters: [String] = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
    var body: some View {
        NavigationView {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
                List(filters, id: \.self) { filter in
                    NavigationLink {
                        CoreImageBasicFiltersCell(string: filter)
                    } label: {
                        Text(filter)
                    }
                }
            }
            .onAppear(perform: loadImage)
        }
    }
    
    func loadImage() {
        
        let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        print(properties)
        
        for property in properties {
            let fltr = CIFilter(name: property as String)
            print(fltr?.attributes ?? "-----------")
        }
        
        
        
        guard let inputImage = UIImage(named: "example") else { return }
        
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        
        //        let currentFilter = CIFilter.sepiaTone()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.intensity = 1
        
        //        let currentFilter = CIFilter.convertRGBtoLab()
        let currentFilter = CIFilter.dither() //  -!!!
        //
        //    let currentFilter = CIFilter.documentEnhancer()
        //      let currentFilter = CIFilter.falseColor()
        //   let currentFilter = CIFilter.maximumComponent()
        //    let currentFilter = CIFilter.minimumComponent()
        
        //   let currentFilter = CIFilter.photoEffectChrome()
        //    let currentFilter = CIFilter.photoEffectFade()
        //  let currentFilter = CIFilter.photoEffectInstant()
        //      let currentFilter = CIFilter.photoEffectMono()
        //let currentFilter = CIFilter.photoEffectNoir()
        //let currentFilter = CIFilter.photoEffectProcess()
        // let currentFilter = CIFilter.photoEffectTonal()
        //  let currentFilter = CIFilter.photoEffectTransfer()
        //     let currentFilter = CIFilter.thermal()
        //  let currentFilter = CIFilter.vignette()
        //  let currentFilter = CIFilter.vignetteEffect()
        //let currentFilter = CIFilter.xRay()
        currentFilter.inputImage = beginImage
        
        //        let currentFilter = CIFilter.pixellate()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.scale = 100
        //
        //        let currentFilter = CIFilter.crystallize()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.radius = 200
        //
        //        let currentFilter = CIFilter.twirlDistortion()
        //        currentFilter.inputImage = beginImage
        //        currentFilter.radius = 1000
        //        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        
        //        let currentFilter = CIFilter.twirlDistortion()
        //        currentFilter.inputImage = beginImage
        //
        //        let amount = 1.0
        //
        //        let inputKeys = currentFilter.inputKeys
        //
        //        if inputKeys.contains(kCIInputIntensityKey) {
        //            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
        //        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
        //        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            
            image = Image(uiImage: uiImage)
        }
    }
    
}

struct CoreImageBasicFiltersCell: View {
    
    var string: String
    @State private var info: String = ""
    
    var body: some View {
        ScrollView{
            Text(info)
                .onAppear(perform: getInfo)
        }
    }
    
    func getInfo() {
        info = CIFilter(name: string)?.attributes.description ?? ""
    }
}

struct CoreImageBasicFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        CoreImageBasicFiltersView()
    }
}
