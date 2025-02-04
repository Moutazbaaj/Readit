struct FeatureButton: View {
    var iconName: String
    var title: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                )
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
    }
}