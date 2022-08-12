//
//  Corners.swift
//  QRScanner
//
//  Created by Mariam B on 9/8/2022.
//

import UIKit
import CoreGraphics


//Corners class to draw only corners in the Camera layout

@IBDesignable
class Corners: UIView {
    
    //MARK: - Corners properties

    @IBInspectable
    var sizeMultiplier : CGFloat = 0.1{
        didSet{
            self.draw(self.bounds)
        }
    }

    @IBInspectable
    var lineWidth : CGFloat = 8{
        didSet{
            self.draw(self.bounds)
        }
    }

    @IBInspectable
    var lineColor : UIColor = UIColor.green{
        didSet{
            self.draw(self.bounds)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    //MARK: - Corners Drawing function
    
    func drawCorners()
    {
        let currentContext = UIGraphicsGetCurrentContext()

        currentContext?.setLineWidth(lineWidth)
        currentContext?.setStrokeColor(lineColor.cgColor)

        //first part of top left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: 0, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width*sizeMultiplier, y: 0))
        currentContext?.strokePath()

        //top rigth corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width - self.bounds.size.width*sizeMultiplier, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height*sizeMultiplier))
        currentContext?.strokePath()

        //bottom rigth corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.bounds.size.height*sizeMultiplier))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width - self.bounds.size.width*sizeMultiplier, y: self.bounds.size.height))
        currentContext?.strokePath()

        //bottom left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width*sizeMultiplier, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: 0, y: self.bounds.size.height - self.bounds.size.height*sizeMultiplier))
        currentContext?.strokePath()

        //second part of top left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: 0, y: self.bounds.size.height*sizeMultiplier))
        currentContext?.addLine(to: CGPoint(x: 0, y: 0))
        currentContext?.strokePath()
    }
    
    //MARK: - Setting the corners layout
    
    func layoutCorners (view: UIView, imageView: UIImageView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: imageView.frame.height),
            self.widthAnchor.constraint(equalToConstant: imageView.frame.width)
            ])
        self.clipsToBounds = true
        self.layer.cornerRadius = 9.5
    }
    
//MARK: - Overriding the draw function
  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawCorners()
    }
}
