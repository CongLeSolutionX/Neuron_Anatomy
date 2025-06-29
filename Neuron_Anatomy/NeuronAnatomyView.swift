//
//MIT License
//
//Copyright © 2025 Cong Le
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//
//  NeuronAnatomyView.swift
//  Neuron_Anatomy
//
//  Created by Cong Le on 6/29/25.
//

import SwiftUI

// MARK: - Data Model
/// Represents a single anatomical part of a neuron for display.
/// This struct cleanly separates the data from the view logic, a core tenet of modern UI development.
struct NeuronPart: Identifiable {
    let id = UUID()
    let icon: String // SF Symbol name for visual representation.
    let name: String
    let function: String
    let analogy: String
    let color: Color
}

/// A static collection of neuron parts, serving as the "database" for our view.
/// Using a static property on the model itself is a clean way to provide sample or default data.
extension NeuronPart {
    static let anatomyData: [NeuronPart] = [
        NeuronPart(icon: "tree.fill", name: "Dendrites", function: "Receive chemical signals from other neurons at connection points called synapses.", analogy: "The neuron's 'ears' or 'antennae'. 📡", color: .green),
        NeuronPart(icon: "building.2.fill", name: "Soma (Cell Body)", function: "The neuron's headquarters. It contains the nucleus and processes incoming signals to determine if a signal should be fired.", analogy: "The neuron's 'command center'. 🏢", color: .orange),
        NeuronPart(icon: "bolt.fill", name: "Axon Hillock", function: "The 'decision-making' region where the soma meets the axon. It sums up the total signals and fires an action potential if the threshold is met.", analogy: "The 'launch button' for the signal. 🚀", color: .purple),
        NeuronPart(icon: "road.lanes", name: "Axon", function: "A long, cable-like projection that carries the electrical signal (action potential) away from the soma toward other neurons.", analogy: "The 'transmission cable'. 🛣️", color: .blue),
        NeuronPart(icon: "shield.lefthalf.filled", name: "Myelin Sheath", function: "An insulating layer formed by glial cells that wraps around the axon, dramatically speeding up signal transmission.", analogy: "The rubber insulation on a wire. 🛡️", color: .cyan),
        NeuronPart(icon: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill", name: "Nodes of Ranvier", function: "Gaps in the myelin sheath where the action potential is regenerated, allowing the signal to 'jump' down the axon (saltatory conduction).", analogy: "Signal 'booster stations'. ⚡", color: .indigo),
        NeuronPart(icon: "point.3.connected.trianglepath.dotted", name: "Axon Terminals", function: "The branched endings of an axon that transmit signals to other neurons by releasing neurotransmitters.", analogy: "The 'transmitters' or 'speakers'. 🔊", color: .pink)
    ]
}

// MARK: - Main View
/// A view dedicated to explaining the anatomy of a neuron.
/// It combines a custom-drawn diagram with a detailed list of its components.
/// This view serves as the main entry point for this educational screen.
struct NeuronAnatomyView: View {
    var body: some View {
        // A navigation view provides a title bar and structural context.
        NavigationView {
            // A ScrollView ensures all content is accessible, even on smaller devices.
            ScrollView {
                VStack(spacing: 20) {
                    // Header text to introduce the topic.
                    Text("The neuron is the fundamental unit of the nervous system, specialized for communication.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)

                    // The custom-drawn visual diagram of the neuron.
                    NeuronDiagramView()
                        .padding(.vertical)

                    // A divider to visually separate the diagram from the details.
                    Divider().padding(.horizontal)
                    
                    // A sub-header for the detailed breakdown section.
                    Text("Anatomical Components")
                        .font(.title2)
                        .fontWeight(.bold)

                    // The list of neuron parts, dynamically generated from our data model.
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(NeuronPart.anatomyData) { part in
                            AnatomyDetailRow(part: part)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Anatomy of a Neuron")
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: - Subviews
/// A view that draws a stylized, annotated diagram of a neuron.
/// Using a dedicated view for the drawing logic keeps the main view's body clean and focused on layout.
struct NeuronDiagramView: View {
    var body: some View {
        // GeometryReader provides the size of the parent view,
        // allowing us to draw the diagram proportionally.
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = 250.0 // Fixed height for simplicity.
            
            ZStack {
                // MARK: Axon Drawing
                // The main "cable" of the neuron.
                Path { path in
                    path.move(to: CGPoint(x: width * 0.35, y: height / 2))
                    path.addLine(to: CGPoint(x: width * 0.8, y: height / 2))
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))

                // MARK: Myelin Sheath Drawing
                // The insulating segments along the axon.
                // We draw these as individual rectangles overlaid on the axon path.
                ForEach(0..<5) { i in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.cyan.opacity(0.6))
                        .frame(width: 25, height: 12)
                        .position(x: width * 0.43 + CGFloat(i * 30), y: height / 2)
                }
                
                // MARK: Axon Terminals Drawing
                // The branching ends of the neuron.
                Path { path in
                    let startPoint = CGPoint(x: width * 0.8, y: height / 2)
                    path.move(to: startPoint)
                    path.addLine(to: CGPoint(x: width * 0.9, y: height / 2 - 30))
                    path.move(to: startPoint)
                    path.addLine(to: CGPoint(x: width * 0.9, y: height / 2))
                    path.move(to: startPoint)
                    path.addLine(to: CGPoint(x: width * 0.9, y: height / 2 + 30))
                }
                .stroke(Color.pink, lineWidth: 2)

                // MARK: Soma (Cell Body) and Nucleus Drawing
                // The main body is a ZStack of two circles.
                ZStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 80, height: 80)
                    Circle()
                        .fill(Color.orange.opacity(0.5))
                        .frame(width: 30, height: 30) // Nucleus
                }
                .position(x: width * 0.2, y: height / 2)

                // MARK: Dendrites Drawing
                // Branching inputs drawn with Paths.
                Path { path in
                    let center = CGPoint(x: width * 0.2, y: height / 2)
                    for i in 0..<7 {
                        let angle = .pi * 2.0 / 7.0 * Double(i) + .pi // Position on the left side
                        path.move(to: center)
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + cos(angle) * 60, y: center.y + sin(angle) * 60),
                            control: CGPoint(x: center.x + cos(angle) * 30, y: center.y + sin(angle) * 30)
                        )
                    }
                }
                .stroke(Color.green, lineWidth: 2)
                
                // MARK: Annotations
                // Using Text views positioned strategically to label the diagram.
                // This makes the diagram itself an educational tool.
                Text("Soma")
                    .font(.caption)
                    .fontWeight(.bold)
                    .position(x: width * 0.2, y: height / 2 + 55)
                
                Text("Dendrites")
                    .font(.caption)
                    .position(x: width * 0.08, y: height / 2)
                
                Text("Axon")
                    .font(.caption)
                    .position(x: width * 0.5, y: height / 2 - 20)
                
                 Text("Myelin")
                    .font(.caption)
                    .position(x: width * 0.5, y: height / 2 + 20)
                
                Text("Terminals")
                    .font(.caption)
                    .position(x: width * 0.9, y: height / 2 - 50)
            }
        }
        .frame(height: 250) // Give the diagram a fixed height.
        .padding(.horizontal)
    }
}


/// A view designed to display the details for a single neuron part.
/// Reusing this view for each item in the list ensures consistency and reduces code duplication.
struct AnatomyDetailRow: View {
    let part: NeuronPart
    
    var body: some View {
        // An HStack arranges the icon and text content horizontally.
        HStack(alignment: .top, spacing: 15) {
            // The icon provides a quick visual cue.
            Image(systemName: part.icon)
                .font(.title)
                .foregroundColor(part.color)
                .frame(width: 35) // Fixed width for consistent alignment.
            
            // A VStack for the textual descriptions.
            VStack(alignment: .leading, spacing: 4) {
                Text(part.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(part.function)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text(part.analogy)
                    .font(.caption)
                    .italic()
                    .padding(.top, 2)
                    .foregroundColor(part.color.opacity(0.9))
            }
        }
    }
}


// MARK: - SwiftUI Preview
/// This code provides a live preview of the `NeuronAnatomyView` in Xcode.
/// It's essential for rapid UI development and testing.
struct NeuronAnatomyView_Previews: PreviewProvider {
    static var previews: some View {
        NeuronAnatomyView()
    }
}
