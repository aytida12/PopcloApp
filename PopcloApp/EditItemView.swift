//
//  EditItemView.swift
//  PopcloApp
//
//  Created by Daniel Dickey on 6/4/22.
//

import SwiftUI
import FirebaseFirestore

struct EditItemView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    let screenWidth = UIScreen.main.bounds.width
    
    //Variable properties
    @State var showingImagePicker = false
    @State var titleLabelColor = Color.popcloBlack
    @State var categoryLabelColor = Color.popcloBlack
    @ObservedObject var viewModel = AddPostViewModel()
    //Item/Post properties
    @State var itemImages: [UIImage]
    @State var itemTitle: String
    @State var itemSize: String
    @State var itemBrand: String
    @State var itemColor: String
    @State var itemCategory: ItemCategory
    @State var itemID: String
    
    // MARK: - View
    var body: some View {
        ///ZStack and Color is for dark mode background
        ZStack {
            Color.popcloWhite.ignoresSafeArea()
            ScrollView {
                //Images
                AddPageImageViewer(postImages: $itemImages)
                    .padding(.bottom)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                
                VStack() {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Title")
                                .bold()
                                .foregroundColor(titleLabelColor)
                            TextField("Add an item title", text: $itemTitle)
                                .font(.callout)
                        }
                        Spacer()
                        AddCategory(category: $itemCategory, categoryLabelColor: $categoryLabelColor)
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack {
                            HStack(spacing: 4) {
                                Text("Details")
                                    .bold()
                                Text("(Optional)")
                                    .font(.footnote)
                                
                            }
                            Divider()
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                    }
                    
                    HStack(spacing: 0) {
                        Text("Brand")
                            .bold()
                        TextField("Add a brand", text: $itemBrand)
                            .font(.callout)
                            .padding(.leading)
                            .disableAutocorrection(true)
                        Spacer()
                        Text("Size")
                            .bold()
                        TextField("# or letter", text: $itemSize)
                            .frame(width: screenWidth * 0.20)
                            .font(.callout)
                            .padding(.leading)
                    }
                    .frame(height: 40)
                    
                    Divider()
                    //Color
                    HStack {
                        Text("Color")
                            .bold()
                        TextField("Add a color", text: $itemColor)
                            .font(.callout)
                            .padding(.leading)
                    }
                    .frame(height: 40)
                }
                .padding(.horizontal)
                //End of add item page
                
            }//Scroll View
        }//Top ZStack
        .fullScreenCover(isPresented: $showingImagePicker) {
            ImagePicker(pickerResults: $itemImages)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Edit Your Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "multiply")
                        .foregroundColor(.popcloBlack)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    updateItem()
                } label: {
                    Text("Save")
                        .bold()
                        .foregroundColor(.popcloBlack)
                }
            }
        }//Toolbar
    }//End of view
    
    // MARK: - Functions
    private func updateItem() {
        //prevents contining and sets red color if empty required fields
        if itemTitle == "" {
            titleLabelColor = .popcloRed
        }
        if itemCategory == .none {
            categoryLabelColor = .popcloRed
        }
        if itemTitle == "" || itemCategory == .none {
            return
        }
        viewModel.postItem(itemImages: itemImages, itemTitle: itemTitle, itemCategory: itemCategory.rawValue, itemBrand: itemBrand, itemColor: itemColor, itemPost: false, itemSize: itemSize, editScreen: true, itemIDParam: itemID)
        //on success
        presentationMode.wrappedValue.dismiss()
    }
    
    
}//End of struct

struct EditItemView_Previews: PreviewProvider {
    @State static var images: [UIImage] = []
    @State static var placeholder = ""
    @State static var itemCat: ItemCategory = .none
    static var previews: some View {
        EditItemView(itemImages: images, itemTitle: placeholder, itemSize: placeholder, itemBrand: placeholder, itemColor: placeholder, itemCategory: itemCat, itemID: placeholder)
    }
}
