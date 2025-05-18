import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

// Chemical Element Data Model
class Element {
  final String symbol;
  final String name;
  final int atomicNumber;
  final double atomicWeight;
  final String category;
  final String description;
  final Color color;
  final String modelUri; // URI to 3D model - could be online or local asset

  Element({
    required this.symbol,
    required this.name,
    required this.atomicNumber,
    required this.atomicWeight,
    required this.category,
    required this.description,
    required this.color,
    required this.modelUri,
  });
}

// Main Periodic Table Screen
class PeriodicTableScreen extends StatefulWidget {
  const PeriodicTableScreen({Key? key}) : super(key: key);

  @override
  State<PeriodicTableScreen> createState() => _PeriodicTableScreenState();
}

class _PeriodicTableScreenState extends State<PeriodicTableScreen> {
  // Sample elements data - in a real app, you'd have all elements
  final List<Element> elements = [
    Element(
      symbol: 'H',
      name: 'Hydrogen',
      atomicNumber: 1,
      atomicWeight: 1.008,
      category: 'Reactive nonmetal',
      description: 'Hydrogen is the lightest element. It is by far the most abundant element in the universe and makes up about 75% of its elemental mass. Stars in the main sequence are mainly composed of hydrogen in its plasma state.',
      color: Colors.blue.shade100,
      modelUri: 'assets/models/character.glb', // Using local model that works
    ),
    Element(
      symbol: 'He',
      name: 'Helium',
      atomicNumber: 2,
      atomicWeight: 4.0026,
      category: 'Noble gas',
      description: 'Helium is the second lightest element. It is a colorless, odorless, tasteless, non-toxic, inert, monatomic gas. It has the lowest boiling point of all the elements and can only be solidified under pressure.',
      color: Colors.purple.shade100,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'Li',
      name: 'Lithium',
      atomicNumber: 3,
      atomicWeight: 6.94,
      category: 'Alkali metal',
      description: 'Lithium is a soft, silvery-white alkali metal. Under standard conditions, it is the lightest metal and the lightest solid element. It is highly reactive and flammable, and must be stored in mineral oil.',
      color: Colors.red.shade100,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'Be',
      name: 'Beryllium',
      atomicNumber: 4,
      atomicWeight: 9.0122,
      category: 'Alkaline earth metal',
      description: 'Beryllium is a relatively rare element in the universe. It is a divalent element which occurs naturally only in combination with other elements to form minerals.',
      color: Colors.green.shade100,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'B',
      name: 'Boron',
      atomicNumber: 5,
      atomicWeight: 10.81,
      category: 'Metalloid',
      description: 'Boron is a chemical element with symbol B and atomic number 5. It is a low-abundance element that is present in the Earth\'s crust and solar system at about one part per million.',
      color: Colors.orange.shade100,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'C',
      name: 'Carbon',
      atomicNumber: 6,
      atomicWeight: 12.011,
      category: 'Reactive nonmetal',
      description: 'Carbon is a chemical element with symbol C and atomic number 6. It is nonmetallic and tetravalent—making four electrons available to form covalent chemical bonds. It is the 15th most abundant element in the Earth\'s crust.',
      color: Colors.grey.shade300,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'N',
      name: 'Nitrogen',
      atomicNumber: 7,
      atomicWeight: 14.007,
      category: 'Reactive nonmetal',
      description: 'Nitrogen is a chemical element with symbol N and atomic number 7. It was first discovered and isolated by Scottish physician Daniel Rutherford in 1772.',
      color: Colors.blue.shade200,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'O',
      name: 'Oxygen',
      atomicNumber: 8,
      atomicWeight: 15.999,
      category: 'Reactive nonmetal',
      description: 'Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table, a highly reactive nonmetal, and an oxidizing agent that readily forms oxides with most elements.',
      color: Colors.red.shade200,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'F',
      name: 'Fluorine',
      atomicNumber: 9,
      atomicWeight: 18.998,
      category: 'Reactive nonmetal',
      description: 'Fluorine is a chemical element with symbol F and atomic number 9. It is the lightest halogen and exists as a highly toxic pale yellow diatomic gas at standard conditions.',
      color: Colors.green.shade200,
      modelUri: 'assets/models/character.glb',
    ),
    Element(
      symbol: 'Ne',
      name: 'Neon',
      atomicNumber: 10,
      atomicWeight: 20.180,
      category: 'Noble gas',
      description: 'Neon is a chemical element with symbol Ne and atomic number 10. It is a noble gas. Neon is a colorless, odorless, inert monatomic gas under standard conditions, with about two-thirds the density of air.',
      color: Colors.purple.shade200,
      modelUri: 'assets/models/character.glb',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Periodic Table'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tap an element to view details and 3D model',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: elements.length,
              itemBuilder: (context, index) {
                final element = elements[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElementDetailScreen(element: element),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: element.color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          element.atomicNumber.toString(),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          element.symbol,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          element.name,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Element Detail Screen
class ElementDetailScreen extends StatelessWidget {
  final Element element;

  const ElementDetailScreen({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(element.name),
        backgroundColor: element.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Element symbol and number
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: element.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      element.atomicNumber.toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      element.symbol,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Element details
            DetailRow(label: 'Name', value: element.name),
            DetailRow(label: 'Atomic Number', value: element.atomicNumber.toString()),
            DetailRow(label: 'Atomic Weight', value: element.atomicWeight.toString()),
            DetailRow(label: 'Category', value: element.category),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              element.description,
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 32),
            
            // AR View button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElementARScreen(element: element),
                    ),
                  );
                },
                icon: const Icon(Icons.view_in_ar),
                label: const Text('View 3D Model in AR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for detail rows
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// AR Screen for Elements
class ElementARScreen extends StatefulWidget {
  final Element element;

  const ElementARScreen({Key? key, required this.element}) : super(key: key);

  @override
  State<ElementARScreen> createState() => _ElementARScreenState();
}

class _ElementARScreenState extends State<ElementARScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? _placedNode;
  bool _isInitialized = false;
  String _debugText = "Initializing AR...";
  int _tapAttempts = 0;
  bool _isModelPlaced = false;

  @override
  void dispose() {
    if (_isInitialized) {
      arSessionManager.dispose();
    }
    super.dispose();
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager.onInitialize(
          showFeaturePoints: true,
          showPlanes: true,
          customPlaneTexturePath: null,
          showWorldOrigin: false,
          handleTaps: true,
        );
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = _onPlaneOrPointTapped;
    
    setState(() {
      _isInitialized = true;
      _debugText = "AR View initialized. Tap on a detected plane to place the ${widget.element.name} model.";
    });
    
    if (kDebugMode) {
      print("AR Session initialized for ${widget.element.name}");
    }
  }

  // Place the element model at a fixed position
  Future<void> _forceAddElementModel() async {
    if (kDebugMode) {
      print("Forcing element model placement");
    }
    
    setState(() {
      _debugText = "Placing ${widget.element.name} model...";
    });

    // Remove any existing node
    if (_placedNode != null) {
      arObjectManager.removeNode(_placedNode!);
      _placedNode = null;
    }

    try {
      // Create a simple transformation matrix - placing object 1 meter in front of camera
      final vector_math.Matrix4 fixedTransform = vector_math.Matrix4.identity()
        ..setTranslation(vector_math.Vector3(0, -0.5, -1.0));

      // Create electron clouds - for a simple atom visualization
      // This is an example of how to add multiple nodes to create a more complex model
      ARNode atomCore = ARNode(
        type: NodeType.localGLTF2, // Changed to local model type
        uri: widget.element.modelUri,
        scale: vector_math.Vector3(1.0, 1.0, 1.0), // Using a larger size
        transformation: fixedTransform,
        name: "${widget.element.symbol}_core",
      );

      bool? didAddCore = await arObjectManager.addNode(atomCore);
      
      if (didAddCore ?? false) {
        _placedNode = atomCore;
        
        // For elements with atomic number > 1, add electron "orbits"
        if (widget.element.atomicNumber > 1) {
          // This would be where you'd add electron orbits in a full implementation
          // For this demo we'll just show the element info
        }
        
        setState(() {
          _debugText = "${widget.element.name} model placed successfully!";
          _isModelPlaced = true;
        });
        
        // Also show atomic information as a floating text
        _showElementInfoCard();
        
      } else {
        setState(() {
          _debugText = "Failed to place ${widget.element.name} model.";
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error placing element model: $e");
      }
      setState(() {
        _debugText = "Error: $e";
      });
    }
  }

  Future<void> _onPlaneOrPointTapped(List<ARHitTestResult?> hitTestResults) async {
    setState(() {
      _tapAttempts++;
      _debugText = "Tap detected! (Attempt #$_tapAttempts)";
    });
    
    if (hitTestResults.isEmpty) {
      setState(() {
        _debugText = "No surface detected. Try tapping on a detected plane.";
      });
      return;
    }

    ARHitTestResult? singleHitTestResult;
    
    try {
      singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult?.type == ARHitTestResultType.plane,
        orElse: () => null,
      );
    } catch (e) {
      setState(() {
        _debugText = "Error finding plane: $e";
      });
      return;
    }
    
    if (singleHitTestResult != null) {
      setState(() {
        _debugText = "Surface detected! Placing ${widget.element.name} model...";
      });

      // Remove existing node if present
      if (_placedNode != null) {
        arObjectManager.removeNode(_placedNode!);
        _placedNode = null;
      }

      try {
        ARNode atomModel = ARNode(
          type: NodeType.localGLTF2,
          uri: widget.element.modelUri,
          scale: vector_math.Vector3(1.0, 1.0, 1.0),
          transformation: singleHitTestResult.worldTransform,
          name: widget.element.symbol,
        );

        bool? didAddNode = await arObjectManager.addNode(atomModel);
        
        if (didAddNode ?? false) {
          _placedNode = atomModel;
          setState(() {
            _debugText = "${widget.element.name} model placed successfully!";
            _isModelPlaced = true;
          });
          
          _showElementInfoCard();
        } else {
          setState(() {
            _debugText = "Failed to place model. Try again.";
          });
        }
      } catch (e) {
        setState(() {
          _debugText = "Error placing model: $e";
        });
      }
    } else {
      setState(() {
        _debugText = "No valid surface detected. Try tapping on the white dots.";
      });
    }
  }

  void _showElementInfoCard() {
    // In a more complete implementation, this would display a floating card
    // with element information in AR space. For now we'll use a simple overlay.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.element.name} (${widget.element.symbol}) - Atomic number: ${widget.element.atomicNumber}"),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.element.symbol} - ${widget.element.name}"),
        backgroundColor: widget.element.color,
      ),
      body: Column(
        children: [
          // Debug text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _debugText,
              style: TextStyle(fontSize: 14, color: Colors.purple),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Note about models
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              children: [
                Text(
                  "Presentation Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "In a production app, each element would have a proper atomic model with nucleus and electron orbitals. For this demo, we're using placeholder models.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Element info card (only shown when model is placed)
          if (_isModelPlaced)
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: widget.element.color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${widget.element.name} (${widget.element.symbol})",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Atomic Number: ${widget.element.atomicNumber}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Atomic Weight: ${widget.element.atomicWeight}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Category: ${widget.element.category}",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Electron Configuration:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getElectronConfig(widget.element.atomicNumber),
                    style: TextStyle(fontSize: 14, fontFamily: "monospace"),
                  ),
                ],
              ),
            ),
          
          // AR View
          Expanded(
            child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Info button
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(widget.element.name),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.element.description),
                        const SizedBox(height: 16),
                        Text("Electrons per shell:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_getElectronShells(widget.element.atomicNumber)),
                        const SizedBox(height: 16),
                        Text("Common uses:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_getElementUses(widget.element.symbol)),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
            tooltip: "Element Info",
            heroTag: "info",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 16),
          
          // Force place button
          FloatingActionButton(
            onPressed: _forceAddElementModel,
            tooltip: "Place Element Model",
            heroTag: "place",
            backgroundColor: Colors.green,
            child: const Icon(Icons.add_circle),
          ),
        ],
      ),
    );
  }
  
  // Helper method to return electron configuration for elements 1-10
  String _getElectronConfig(int atomicNumber) {
    switch (atomicNumber) {
      case 1: return "1s¹";
      case 2: return "1s²";
      case 3: return "1s² 2s¹";
      case 4: return "1s² 2s²";
      case 5: return "1s² 2s² 2p¹";
      case 6: return "1s² 2s² 2p²";
      case 7: return "1s² 2s² 2p³";
      case 8: return "1s² 2s² 2p⁴";
      case 9: return "1s² 2s² 2p⁵";
      case 10: return "1s² 2s² 2p⁶";
      default: return "Not available";
    }
  }
  
  // Helper method to return electron shells for elements 1-10
  String _getElectronShells(int atomicNumber) {
    switch (atomicNumber) {
      case 1: return "K: 1";
      case 2: return "K: 2";
      case 3: return "K: 2, L: 1";
      case 4: return "K: 2, L: 2";
      case 5: return "K: 2, L: 3";
      case 6: return "K: 2, L: 4";
      case 7: return "K: 2, L: 5";
      case 8: return "K: 2, L: 6";
      case 9: return "K: 2, L: 7";
      case 10: return "K: 2, L: 8";
      default: return "Not available";
    }
  }
  
  // Helper method to return common uses for elements
  String _getElementUses(String symbol) {
    switch (symbol) {
      case 'H': return "Fuel, fertilizer production, and hydrogen fuel cells";
      case 'He': return "Balloons, deep-sea diving tanks, and cooling MRI machines";
      case 'Li': return "Batteries, ceramics, and medications";
      case 'Be': return "Aerospace components, nuclear reactors, and X-ray equipment";
      case 'B': return "Glass manufacturing, detergents, and semiconductors";
      case 'C': return "Fuels, steel production, and all organic compounds";
      case 'N': return "Fertilizers, explosives, and refrigeration";
      case 'O': return "Life support, combustion, and oxidation processes";
      case 'F': return "Toothpaste, non-stick coatings, and refrigerants";
      case 'Ne': return "Neon signs, lasers, and cryogenic refrigeration";
      default: return "Not available";
    }
  }
} 