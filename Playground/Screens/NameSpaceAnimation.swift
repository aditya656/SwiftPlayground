//
//  NameSpaceAnimation.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct NameSpaceAnimation: View {
    @State private var isProfileExpanded: Bool = false
    @State var isTopCardVisible = false
    @State var isProfileCardVisible = false
    
    @Namespace private var profileAnimation
    @Namespace private var profileAvatar
    @Namespace private var profileName
    @Namespace private var profileDescription
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                if isProfileExpanded {
                    profileExpandedView
                } else {
                    profileCollapsedView
                }
                
                profileContent
            }
            VStack {
                Color.red
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                    .padding()
                    .opacity(isTopCardVisible ? 1 : 0)
            }
        }
    }
    
    var profileCollapsedView: some View {
            HStack {
                Image(systemName: "house.fill")
                    .resizable()
                    .matchedGeometryEffect(id: profileAvatar, in: profileAnimation)
                    .frame(width: 70, height: 70)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isProfileExpanded = true
                        }
                    }
                VStack(alignment: .leading) {
                    Text("Profile Name")
                        .matchedGeometryEffect(id: profileName, in: profileAnimation)
                        .font(.title)
                    Text("Description")
                        .matchedGeometryEffect(id: profileDescription, in: profileAnimation)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                Spacer()
            }
            .padding()
    }
    
    var profileExpandedView: some View {
        VStack {
            Image(systemName: "house.fill")
                .resizable()
                .matchedGeometryEffect(id: profileAvatar, in: profileAnimation)
                .frame(width: 120, height: 120)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isProfileExpanded = false
                    }
                }
            VStack {
                Text("Profile Name")
                    .matchedGeometryEffect(id: profileName, in: profileAnimation)
                    .font(.title)
                Text("Description")
                    .matchedGeometryEffect(id: profileDescription, in: profileAnimation)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillu")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
            }
        }
    }
    
    var profileContent: some View {
        return ZStack(alignment: .top) {
            LazyVStack {
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                GeometryReader { proxy in
                    Color.green
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .frame(height: 200)
                        .opacity(isTopCardVisible ? 0 : 1)
                        .onChange(of: proxy.frame(in: .global).minY) { newValue in
                            if newValue < 80 {
                                isTopCardVisible = true
                            } else {
                                isTopCardVisible = false
                            }
                        }
                }
                .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
                Color.gray
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 200)
            }
            .padding()
        }
    }
}

#Preview {
    NameSpaceAnimation()
}
