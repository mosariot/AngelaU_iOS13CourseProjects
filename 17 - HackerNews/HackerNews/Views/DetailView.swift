//
//  DetailView.swift
//  HackerNews
//
//  Created by Александр Воробьев on 06.07.2020.
//  Copyright © 2020 Александр Воробьев. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}

