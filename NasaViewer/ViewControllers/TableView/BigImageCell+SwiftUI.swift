//
//  BigImageCell+SwiftUI.swift
//  NasaViewer
//
//  Created by Maciej Lipiec on 2023-03-29.
//

import SwiftUI

struct BigImageCell_SwiftUI: View {
    
    //MARK: PROPERTIES
    var image: UIImage?
    var title: String
    var description: String
    var date: String
    var copyright: String
    var body: some View {
        //MARK: Image
            VStack {
                if image == nil {
                    ProgressView()
                } else {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                }
                HStack {
                    Text(title)
                        .font(.title2)
                    Spacer()
                }
                .padding(.bottom, 4)
                .padding(.horizontal, 4)
                HStack {
                    Text(description)
                        .font(.footnote)
                    Spacer()
                }
                .padding(.bottom, 4)
                .padding(.horizontal, 4)
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(date)
                        .font(.caption)
                        .lineLimit(1)
                    Text(copyright)
                        .font(.caption)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.bottom, 4)
                .padding(.horizontal, 4)
                Spacer()
            }
    }    
}

struct BigImageCell_SwiftUI_Previews: PreviewProvider {
    
    static var image = UIImage(named: "DaVinciRisingLikaiLin_1024")
    static var title = "Title"
    static var description = "Description goes here, and we should have it a little bit longer than title so i'm testing it"
    static var date = "21 oktober 2023"
    static var copyright = "Copyright"
    
    static var previews: some View {
        BigImageCell_SwiftUI(image: image, title: title, description: description, date: date, copyright: copyright)
            .previewLayout(.sizeThatFits)
    }
}
