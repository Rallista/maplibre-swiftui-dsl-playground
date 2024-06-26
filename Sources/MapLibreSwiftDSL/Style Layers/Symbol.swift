import Foundation
import InternalUtils
import MapLibre
import MapLibreSwiftMacros

@MLNStyleProperty<Double>("iconRotation", supportsInterpolation: true)
@MLNStyleProperty<UIColor>("iconColor", supportsInterpolation: true)
@MLNStyleProperty<UIColor>("textColor", supportsInterpolation: true)
@MLNStyleProperty<Double>("textFontSize", supportsInterpolation: true)
@MLNStyleProperty<String>("text", supportsInterpolation: false)
@MLNStyleProperty<Bool>("iconAllowsOverlap", supportsInterpolation: false)

public struct SymbolStyleLayer: SourceBoundVectorStyleLayerDefinition {
    public let identifier: String
    public var insertionPosition: LayerInsertionPosition = .aboveOthers
    public var isVisible: Bool = true
    public var maximumZoomLevel: Float? = nil
    public var minimumZoomLevel: Float? = nil

    public var source: StyleLayerSource
    public var predicate: NSPredicate?

    public init(identifier: String, source: Source) {
        self.identifier = identifier
        self.source = .source(source)
    }

    public init(identifier: String, source: MLNSource) {
        self.identifier = identifier
        self.source = .mglSource(source)
    }

    public func makeStyleLayer(style: MLNStyle) -> StyleLayer {
        let styleSource = addSource(to: style)

        // Register the images with the map style
        for image in iconImages {
            style.setImage(image, forName: image.sha256())
        }
        return SymbolStyleLayerInternal(definition: self, mglSource: styleSource)
    }

    // TODO: Other properties and their modifiers
    fileprivate var iconImageName: NSExpression?

    private var iconImages = [UIImage]()

    // MARK: - Modifiers

    public func iconImage(_ image: UIImage) -> Self {
        modified(self) { it in
            it.iconImageName = NSExpression(forConstantValue: image.sha256())
            it.iconImages = [image]
        }
    }

    // FIXME: This appears to be broken upstream; waiting for a new release
//    public func iconImage(attribute: String, mappings: [AnyHashable: UIImage], default defaultImage: UIImage) -> Self
//    {
//        return modified(self) { it in
//            it.iconImageName = NSExpression(forMLNMatchingKey: NSExpression(forConstantValue: attribute),
//                                            in: Dictionary(uniqueKeysWithValues: mappings.map({ (k, v) in
//                (NSExpression(forConstantValue: k), NSExpression(forConstantValue: v.sha256()))
//            })),
//                                            default: NSExpression(forConstantValue: defaultImage.sha256()))
//            it.iconImages = mappings.values + [defaultImage]
//        }
//    }
}

private struct SymbolStyleLayerInternal: StyleLayer {
    private var definition: SymbolStyleLayer
    private let mglSource: MLNSource

    public var identifier: String { definition.identifier }
    public var insertionPosition: LayerInsertionPosition {
        get { definition.insertionPosition }
        set { definition.insertionPosition = newValue }
    }

    public var isVisible: Bool {
        get { definition.isVisible }
        set { definition.isVisible = newValue }
    }

    public var maximumZoomLevel: Float? {
        get { definition.maximumZoomLevel }
        set { definition.maximumZoomLevel = newValue }
    }

    public var minimumZoomLevel: Float? {
        get { definition.minimumZoomLevel }
        set { definition.minimumZoomLevel = newValue }
    }

    init(definition: SymbolStyleLayer, mglSource: MLNSource) {
        self.definition = definition
        self.mglSource = mglSource
    }

    public func makeMLNStyleLayer() -> MLNStyleLayer {
        let result = MLNSymbolStyleLayer(identifier: identifier, source: mglSource)

        result.iconImageName = definition.iconImageName
        result.iconRotation = definition.iconRotation
        result.iconColor = definition.iconColor
        result.text = definition.text
        result.textColor = definition.textColor
        result.textFontSize = definition.textFontSize

        result.iconAllowsOverlap = definition.iconAllowsOverlap

        result.predicate = definition.predicate

        return result
    }
}
