//
//  Tin.swift
//  Tin
//
//  Created by Loren Olson on 12/28/16.
//  Created at the School of Arts, Media and Engineering,
//  Herberger Institute for Design and the Arts,
//  Arizona State University.
//  Copyright (c) 2017 Arizona Board of Regents on behalf of Arizona State University
//

import Cocoa


public var tin = Tin()


public protocol TinRenderProtocol {
    
    var delegate: Tin { get set }
    
    // rendering setup
    func prepare(frame: NSRect)
    
    
    // rendering cycle
    func prepareForUpdate(frame: NSRect)
    func didFinishUpdate()
    
    
    // drawing methods
    func background(red: CGFloat, green: CGFloat, blue: CGFloat)
    
    func ellipse(inRect rect: CGRect)
    func rect(withRect rect: CGRect)
    
    func line(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)
    func lineWidth(_ width: CGFloat)
    func triangle(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, x3: CGFloat, y3: CGFloat)
    
    func pathBegin()
    func pathVertex(at point: CGPoint)
    func pathAddCurve(to: CGPoint, control1: CGPoint, control2: CGPoint)
    func pathClose()
    func pathEnd()
    
    
    // color state
    func setStrokeColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    func setFillColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    func strokeColor() -> NSColor
    func fillColor() -> NSColor
    
    
    // context state & transformations
    func pushState()
    func popState()
    func translate(dx: CGFloat, dy: CGFloat)
    func rotate(by angle: CGFloat)
    func scale(by amount: CGFloat)
    
    
    // image & text
    func image(x: CGFloat, y: CGFloat, image: TImage)
    func text(message: String, x: CGFloat, y: CGFloat, font: TFont)
    
}


public class Tin {
    
    public var fill = true
    public var stroke = true
    public var size: NSSize = NSSize(width: 0, height: 0)
    public var midX: CGFloat = 0.0
    public var midY: CGFloat = 0.0
    public var mouseX: CGFloat = 0.0
    public var mouseY: CGFloat = 0.0
    public var pmouseX: CGFloat = 0.0
    public var pmouseY: CGFloat = 0.0
    public var frameCount = 0
    
    var pathVertexCount = 0
    
    public var render: TinRenderProtocol?
    
    
    
    init() {
        render = nil
    }
    
    
    func makeRenderer() {
        render = CoreGraphicsRenderer(delegate:self)
    }
    
    
    func prepare(frame: NSRect) {
        render?.delegate = self
        render?.prepare(frame: frame)
        reset(width: frame.width, height: frame.height)
    }
    
    
    // MARK: - Rendering cycle
    
    
    func prepareForUpdate(frame: NSRect) {
        render?.prepareForUpdate(frame: frame)
    }
    
    
    func didFinishUpdate() {
        render?.didFinishUpdate()
    }
    
    
    
    func reset(width: CGFloat, height: CGFloat) {
        size = NSSize(width: width, height: height)
        midX = width / 2.0
        midY = height / 2.0
        fill = true
        stroke = true
        lineWidth(2.0)
        setFillColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        setStrokeColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    
    // MARK: - Drawing methods
    
    
    public func background(red: CGFloat, green: CGFloat, blue: CGFloat) {
        render?.background(red: red, green: green, blue: blue)
    }
    
    
    // Ellipse methods
    
    // Draw an ellipse. Input is left,bottom and right,top coordinates.
    public func ellipse(left: CGFloat, bottom: CGFloat, right: CGFloat, top: CGFloat) {
        let r = CGRect(x: left, y: bottom, width: right - left + 1.0, height: top - bottom + 1.0)
        render?.ellipse(inRect: r)
    }
    
    // Draw an ellipse. Input is left,bottom coordinate and width,height size.
    public func ellipse(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let r = CGRect(x: x, y: y, width: width, height: height)
        render?.ellipse(inRect: r)
    }
    
    // Draw an ellipse. Input is origin (left,bottom) as CGPoint and size as CGSize
    public func ellipse(origin: CGPoint, size: CGSize) {
        let r = CGRect(origin: origin, size: size)
        render?.ellipse(inRect: r)
    }
    
    // Draw an ellipse. Input is centerX,centerY coordinate and width,height size.
    public func ellipse(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        let r = CGRect(x: centerX - width/2.0, y: centerY - height/2.0, width: width, height: height)
        render?.ellipse(inRect: r)
    }
    
    // Draw an ellipse. Input is center as CGPoint and size as CGSize
    public func ellipse(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width/2.0, y: center.y - size.height/2.0)
        let r = CGRect(origin: origin, size: size)
        render?.ellipse(inRect: r)
    }
    
    // Draw an ellipse. Input is a CGRect struct.
    public func ellipse(inRect rect: CGRect) {
        render?.ellipse(inRect: rect)
    }
    
    
    // Line methods
    
    public func line(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        render?.line(x1: x1, y1: y1, x2: x2, y2: y2)
    }
    
    public func lineWidth(_ width: CGFloat) {
        render?.lineWidth(width)
    }
    
    
    // Rectangle methods
    
    // Draw a rectangle. Input is left,bottom and right,top coordinates.
    public func rect(left: CGFloat, bottom: CGFloat, right: CGFloat, top: CGFloat) {
        let r = CGRect(x: left, y: bottom, width: right - left + 1.0, height: top - bottom + 1.0)
        render?.rect(withRect: r)
    }
    
    // Draw a rectangle. Input is left,bottom coordinate and width,height size.
    public func rect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let r = CGRect(x: x, y: y, width: width, height: height)
        render?.rect(withRect: r)
    }
    
    // Draw a rectangle. Input is origin (left,bottom) as CGPoint and size as CGSize
    public func rect(origin: CGPoint, size: CGSize) {
        let r = CGRect(origin: origin, size: size)
        render?.rect(withRect: r)
    }
    
    // Draw a rectangle. Input is centerX,centerY coordinate and width,height size.
    public func rect(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        let r = CGRect(x: centerX - width/2.0, y: centerY - height/2.0, width: width, height: height)
        render?.rect(withRect: r)
    }
    
    // Draw a rectangle. Input is center as CGPoint and size as CGSize
    public func rect(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width/2.0, y: center.y - size.height/2.0)
        let r = CGRect(origin: origin, size: size)
        render?.rect(withRect: r)
    }
    
    // Draw a rectangle. Input is a CGRect struct.
    public func rect(withRect rect: CGRect) {
        render?.rect(withRect: rect)
    }
    
    
    
    public func triangle(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, x3: CGFloat, y3: CGFloat) {
        render?.triangle(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3)
    }
    
    
    // Path methods
    
    
    // Create a new path.
    public func pathBegin() {
        render?.pathBegin()
        pathVertexCount = 0
    }
    
    // Add a new point to the current path. (input 2 CGFloats)
    public func pathVertex(x: CGFloat, y: CGFloat) {
        let point = CGPoint(x: x, y: y)
        render?.pathVertex(at: point)
        pathVertexCount += 1
    }
    
    // Add a new point to the current path. (input CGPoint)
    public func pathVertex(at point: CGPoint) {
        render?.pathVertex(at: point)
        pathVertexCount += 1
    }
    
    // Add a bezier curve to the current path
    public func pathAddCurve(to: CGPoint, control1: CGPoint, control2: CGPoint) {
        render?.pathAddCurve(to: to, control1: control1, control2: control2)
        pathVertexCount += 4
    }
    
    // Close the current line, connecting the current point to the first point.
    public func pathClose() {
        render?.pathClose()
        pathEnd()
    }
    
    // Stroke/Fill the current path.
    public func pathEnd() {
        render?.pathEnd()
        pathVertexCount = 0
    }
    
    
    // MARK: - Color state
    
    
    public func setStrokeColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        render?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    public func setFillColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        render?.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public func strokeColor() -> NSColor {
        return (render?.strokeColor())!
    }
    
    public func fillColor() -> NSColor {
        return (render?.fillColor())!
    }
    
    
    // MARK: - Context state and Transformations
    
    
    public func pushState() {
        render?.pushState()
    }
    
    public func popState() {
        render?.popState()
    }
    
    public func translate(dx: CGFloat, dy: CGFloat) {
        render?.translate(dx: dx, dy: dy)
    }
    
    public func rotate(by angle: CGFloat) {
        render?.rotate(by: angle)
    }
    
    public func scale(by amount: CGFloat) {
        render?.scale(by: amount)
    }
    
    
    // MARK: - Image
    
    
    public func image(x: CGFloat, y: CGFloat, image: TImage) {
        render?.image(x: x, y: y, image: image)
    }
    
    
    // MARK: - Text
    
    
    public func text(message: String, x: CGFloat, y: CGFloat, font: TFont) {
        render?.text(message: message, x: x, y: y, font: font)
    }
    
    
    public func mouseMoved(to point: CGPoint) {
        pmouseX = mouseX
        pmouseY = mouseY
        mouseX = point.x
        mouseY = point.y
    }
    
    public func updateFrameCount() {
        frameCount += 1
    }
    
}
