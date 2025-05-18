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
import 'dart:math' as math;

enum ModelType { local, web }

class ModelOption {
  final String name;
  final ModelType type;
  final String uri;
  final vector_math.Vector3 scale;

  ModelOption({
    required this.name,
    required this.type,
    required this.uri,
    required this.scale,
  });
}

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? _placedNode;
  bool _isInitialized = false;
  String _debugText = "Initializing AR...";

  // Simple counter to track tap attempts
  int _tapAttempts = 0;

  // Model options
  final List<ModelOption> _modelOptions = [
    ModelOption(
      name: "Local Character",
      type: ModelType.local,
      uri: "assets/models/character.glb",
      scale: vector_math.Vector3(
          2.0, 2.0, 2.0), // Much larger scale for human-sized appearance
    ),
    ModelOption(
        name: "Web Duck",
        type: ModelType.web,
        uri:
            "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Duck/glTF-Binary/Duck.glb",
        scale: vector_math.Vector3(0.2, 0.2, 0.2)),
    ModelOption(
        name: "Web Box",
        type: ModelType.web,
        uri:
            "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Box/glTF-Binary/Box.glb",
        scale: vector_math.Vector3(0.3, 0.3, 0.3)),
    ModelOption(
        name: "Web Sphere",
        type: ModelType.web,
        uri:
            "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Sphere/glTF-Binary/Sphere.glb",
        scale: vector_math.Vector3(0.3, 0.3, 0.3)),
  ];

  ModelOption? _selectedModel;

  @override
  void initState() {
    super.initState();
    _selectedModel =
        _modelOptions.first; // Default to the first model (Local Character)
  }

  @override
  void dispose() {
    super.dispose();
    if (_isInitialized) {
      arSessionManager.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Object Placement'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: PopupMenuButton<ModelOption>(
              icon: const Icon(Icons.folder_zip),
              onSelected: (ModelOption selected) {
                setState(() {
                  _selectedModel = selected;
                  _debugText = "Selected model: ${selected.name}";
                });
                if (kDebugMode) {
                  print("Selected model: ${selected.name}");
                }
              },
              itemBuilder: (BuildContext context) {
                return _modelOptions.map((ModelOption option) {
                  return PopupMenuItem<ModelOption>(
                    value: option,
                    child: Text(
                      option.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.tertiary,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            if (_selectedModel != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.view_in_ar,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Selected: ${_selectedModel!.name}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            // Debug info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _debugText,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ARView(
                    onARViewCreated: onARViewCreated,
                    planeDetectionConfig:
                        PlaneDetectionConfig.horizontalAndVertical,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Tap Attempts: $_tapAttempts",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _cleanupScene,
            tooltip: "Reset AR",
            heroTag: "reset",
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _placedNode == null
                ? null
                : () {
                    if (_placedNode != null) {
                      if (kDebugMode) {
                        print(
                            "Attempting to remove node: ${_placedNode!.name}");
                      }
                      setState(() {
                        _debugText = "Removing node: ${_placedNode!.name}";
                      });
                      arObjectManager.removeNode(_placedNode!);
                      _placedNode = null;
                      setState(() {
                        _debugText = "Node removed";
                      });
                    }
                  },
            tooltip: "Remove object",
            heroTag: "remove",
            backgroundColor: _placedNode == null
                ? Colors.grey
                : Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _selectedModel == null ? null : _forceAddObject,
            tooltip: "Add object",
            heroTag: "add",
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
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
      _debugText =
          "AR View initialized. Tap on a detected plane to place an object.";
    });

    if (kDebugMode) {
      print("AR Session initialized successfully");
    }
  }

  // Method to clean up any placed objects
  Future<void> _cleanupScene() async {
    if (kDebugMode) {
      print("Cleaning up scene");
    }

    setState(() {
      _debugText = "Cleaning up scene...";
      _tapAttempts = 0;
    });

    // Remove any existing nodes
    if (_placedNode != null) {
      arObjectManager.removeNode(_placedNode!);
      _placedNode = null;
    }

    setState(() {
      _debugText = "Scene cleaned. Tap on a detected plane to place an object.";
    });
  }

  // This method tries to add an object at a fixed position in front of the camera
  Future<void> _forceAddObject() async {
    if (_selectedModel == null) {
      setState(() {
        _debugText = "No model selected";
      });
      return;
    }

    if (kDebugMode) {
      print("Forcing object placement for: ${_selectedModel!.name}");
    }

    setState(() {
      _debugText = "Forcing object placement for: ${_selectedModel!.name}";
    });

    // Remove any existing node
    if (_placedNode != null) {
      arObjectManager.removeNode(_placedNode!);
      _placedNode = null;
    }

    try {
      // Create a simple transformation matrix - placing object 1 meter in front of camera
      // This is a simplistic approach that places the object at a fixed position
      final vector_math.Matrix4 fixedTransform = vector_math.Matrix4.identity()
        ..setTranslation(vector_math.Vector3(0, -0.5,
            -1.0)); // x=0, y=-0.5 (slightly below), z=-1 (1 meter in front)

      ARNode newNode = ARNode(
        type: _selectedModel!.type == ModelType.local
            ? NodeType.localGLTF2
            : NodeType.webGLB,
        uri: _selectedModel!.uri,
        scale: _selectedModel!.scale,
        transformation: fixedTransform,
        name: _selectedModel!.name,
      );

      bool? didAddNode = await arObjectManager.addNode(newNode);

      if (didAddNode ?? false) {
        _placedNode = newNode;
        if (kDebugMode) {
          print("Force-added node '${newNode.name}' successfully!");
        }
        setState(() {
          _debugText = "Force-added ${_selectedModel!.name} successfully!";
        });
      } else {
        if (kDebugMode) {
          print("Failed to force-add node. addNode returned false/null.");
        }
        setState(() {
          _debugText = "Failed to force-add node. addNode returned false/null.";
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error forcing node: $e");
      }
      setState(() {
        _debugText = "Error forcing node: $e";
      });
    }
  }

  Future<void> _onPlaneOrPointTapped(
      List<ARHitTestResult?> hitTestResults) async {
    // Increment tap counter
    setState(() {
      _tapAttempts++;
      _debugText = "Tap detected! (Attempt #$_tapAttempts)";
    });

    if (_selectedModel == null) {
      if (kDebugMode) {
        print("No model selected to place.");
      }
      setState(() {
        _debugText = "No model selected to place.";
      });
      return;
    }

    if (hitTestResults.isEmpty) {
      if (kDebugMode) {
        print("Hit test returned empty results");
      }
      setState(() {
        _debugText =
            "Hit test returned empty results. Try tapping closer to the white dots.";
      });
      return;
    }

    if (kDebugMode) {
      print("Hit test returned ${hitTestResults.length} results");
      for (int i = 0; i < hitTestResults.length; i++) {
        final result = hitTestResults[i];
        print("Result $i: ${result?.type}, distance: ${result?.distance}");
      }
    }

    ARHitTestResult? singleHitTestResult;

    try {
      singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult?.type == ARHitTestResultType.plane,
        orElse: () => null,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error finding plane hit result: $e");
      }
      setState(() {
        _debugText = "Error finding plane hit result: $e";
      });
      return;
    }

    if (singleHitTestResult != null) {
      if (kDebugMode) {
        print(
            "Valid plane hit detected at distance: ${singleHitTestResult.distance}");
        print("Attempting to place ${_selectedModel!.name}");
        print("Model URI: ${_selectedModel!.uri}");
        print("Model Type: ${_selectedModel!.type}");
      }

      setState(() {
        _debugText = "Valid plane hit! Placing ${_selectedModel!.name}...";
      });

      // Remove existing node if present
      if (_placedNode != null) {
        arObjectManager.removeNode(_placedNode!);
        _placedNode = null;
        if (kDebugMode) {
          print("Removed existing node");
        }
      }

      try {
        // For models (local or web)
        ARNode newNode = ARNode(
          type: _selectedModel!.type == ModelType.local
              ? NodeType.localGLTF2
              : NodeType.webGLB,
          uri: _selectedModel!.uri,
          scale: _selectedModel!.scale,
          transformation: singleHitTestResult.worldTransform,
          name: _selectedModel!.name,
        );

        // Add some debugging for the transformation matrix
        if (kDebugMode) {
          print("Transformation matrix: ${singleHitTestResult.worldTransform}");

          // Print translation component
          vector_math.Vector3 translation = vector_math.Vector3.zero();
          translation
              .setFrom(singleHitTestResult.worldTransform.getTranslation());
          print(
              "Translation: x=${translation.x}, y=${translation.y}, z=${translation.z}");
        }

        bool? didAddNode = await arObjectManager.addNode(newNode);

        if (didAddNode ?? false) {
          _placedNode = newNode;
          if (kDebugMode) {
            print("Node '${newNode.name}' added successfully!");
          }
          setState(() {
            _debugText = "Added ${_selectedModel!.name} successfully!";
          });
        } else {
          if (kDebugMode) {
            print("Failed to add node. addNode returned ${didAddNode}");
          }
          setState(() {
            _debugText = "Failed to add node. Return value: ${didAddNode}";
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error adding node: $e");
        }
        setState(() {
          _debugText = "Error adding node: $e";
        });
      }
    } else {
      if (kDebugMode) {
        print("No valid plane hit detected");
      }
      setState(() {
        _debugText =
            "No valid plane hit detected. Try tapping directly on the white dots.";
      });
    }
  }
}
