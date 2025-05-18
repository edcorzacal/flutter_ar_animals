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

// Animal Data Model
class Animal {
  final String name;
  final String letter;
  final String habitat;
  final String description;
  final String diet;
  final Color color;
  final String modelUri;

  Animal({
    required this.name,
    required this.letter,
    required this.habitat,
    required this.description,
    required this.diet,
    required this.color,
    required this.modelUri,
  });
}

// Main Animal Screen
class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  // Animal data - organized by first letter
  final List<Animal> animals = [
    Animal(
      name: 'Alligator',
      letter: 'A',
      habitat: 'Freshwater wetlands and swamps',
      description:
          'The American alligator is a large reptile native to the southeastern United States. They are apex predators and play an important role in their ecosystem.',
      diet: 'Fish, birds, mammals, and other reptiles',
      color: Colors.green.shade100,
      modelUri: 'assets/models/alligator.glb',
    ),
    Animal(
      name: 'Bear',
      letter: 'B',
      habitat: 'Forests and mountains',
      description:
          'Bears are large mammals found across North America, Europe, and Asia. They are known for their strength and intelligence.',
      diet: 'Omnivorous - plants, berries, fish, and small mammals',
      color: Colors.brown.shade100,
      modelUri: 'assets/models/bear.glb',
    ),
    Animal(
      name: 'Cat',
      letter: 'C',
      habitat: 'Domestic and wild environments',
      description:
          'Cats are small, carnivorous mammals that have been domesticated for thousands of years. They are known for their agility and hunting skills.',
      diet: 'Carnivorous - primarily meat',
      color: Colors.orange.shade100,
      modelUri: 'assets/models/cat.glb',
    ),
    Animal(
      name: 'Dog',
      letter: 'D',
      habitat: 'Domestic and wild environments',
      description:
          'Dogs are domesticated mammals and one of the most popular pets worldwide. They are known for their loyalty and intelligence.',
      diet: 'Omnivorous - meat and plant-based foods',
      color: Colors.brown.shade200,
      modelUri: 'assets/models/dog.glb',
    ),
    Animal(
      name: 'Elephant',
      letter: 'E',
      habitat: 'Savannas and forests',
      description:
          'Elephants are the largest land animals on Earth. They are known for their intelligence, memory, and strong social bonds.',
      diet: 'Herbivorous - grasses, leaves, bark, and fruits',
      color: Colors.grey.shade300,
      modelUri: 'assets/models/elephant.glb',
    ),
    Animal(
      name: 'Fox',
      letter: 'F',
      habitat: 'Various habitats including forests and urban areas',
      description:
          'Foxes are small to medium-sized omnivorous mammals. They are known for their cunning and adaptability.',
      diet: 'Omnivorous - small mammals, birds, fruits, and insects',
      color: Colors.orange.shade200,
      modelUri: 'assets/models/fox.glb',
    ),
    Animal(
      name: 'Giraffe',
      letter: 'G',
      habitat: 'African savannas',
      description:
          'Giraffes are the tallest living terrestrial animals. They are known for their long necks and distinctive spotted patterns.',
      diet: 'Herbivorous - leaves, fruits, and flowers from tall trees',
      color: Colors.yellow.shade100,
      modelUri: 'assets/models/giraffe.glb',
    ),
    Animal(
      name: 'Hippo',
      letter: 'H',
      habitat: 'Rivers and lakes in Africa',
      description:
          'Hippos are large, mostly herbivorous mammals. Despite their size, they are excellent swimmers.',
      diet: 'Herbivorous - grasses and aquatic plants',
      color: Colors.purple.shade100,
      modelUri: 'assets/models/hippo.glb',
    ),
    Animal(
      name: 'Iguana',
      letter: 'I',
      habitat: 'Tropical forests and deserts',
      description:
          'Iguanas are large lizards native to tropical areas. They are known for their distinctive spines and dewlaps.',
      diet: 'Herbivorous - leaves, flowers, and fruits',
      color: Colors.green.shade200,
      modelUri: 'assets/models/iguana.glb',
    ),
    Animal(
      name: 'Jaguar',
      letter: 'J',
      habitat: 'Rainforests and grasslands',
      description:
          'Jaguars are the largest cats in the Americas. They are known for their powerful jaws and distinctive spotted coat.',
      diet: 'Carnivorous - deer, peccaries, and other large prey',
      color: Colors.orange.shade300,
      modelUri: 'assets/models/jaguar.glb',
    ),
    Animal(
      name: 'Kangaroo',
      letter: 'K',
      habitat: 'Australian grasslands and forests',
      description:
          'Kangaroos are marsupials native to Australia. They are known for their powerful hind legs and pouches.',
      diet: 'Herbivorous - grasses and plants',
      color: Colors.brown.shade100,
      modelUri: 'assets/models/kangaroo.glb',
    ),
    Animal(
      name: 'Lion',
      letter: 'L',
      habitat: 'African savannas',
      description:
          'Lions are large cats known as the "king of the jungle". They live in social groups called prides.',
      diet: 'Carnivorous - large mammals like zebras and wildebeests',
      color: Colors.orange.shade100,
      modelUri: 'assets/models/lion.glb',
    ),
    Animal(
      name: 'Monkey',
      letter: 'M',
      habitat: 'Tropical forests',
      description:
          'Monkeys are primates known for their intelligence and social behavior. They are found in various habitats worldwide.',
      diet: 'Omnivorous - fruits, leaves, insects, and small animals',
      color: Colors.brown.shade200,
      modelUri: 'assets/models/monkey.glb',
    ),
    Animal(
      name: 'Narwhal',
      letter: 'N',
      habitat: 'Arctic waters',
      description:
          'Narwhals are medium-sized whales known for their long tusks. They are found in Arctic waters.',
      diet: 'Carnivorous - fish, squid, and shrimp',
      color: Colors.blue.shade100,
      modelUri: 'assets/models/narwhal.glb',
    ),
    Animal(
      name: 'Octopus',
      letter: 'O',
      habitat: 'Ocean depths',
      description:
          'Octopuses are highly intelligent invertebrates. They are known for their eight arms and ability to change color.',
      diet: 'Carnivorous - crabs, fish, and other marine animals',
      color: Colors.purple.shade200,
      modelUri: 'assets/models/octopus.glb',
    ),
    Animal(
      name: 'Penguin',
      letter: 'P',
      habitat: 'Antarctic and sub-Antarctic regions',
      description:
          'Penguins are flightless birds adapted to life in water. They are known for their distinctive black and white coloring.',
      diet: 'Carnivorous - fish, squid, and krill',
      color: Colors.blue.shade200,
      modelUri: 'assets/models/penguin.glb',
    ),
    Animal(
      name: 'Quokka',
      letter: 'Q',
      habitat: 'Australian islands',
      description:
          'Quokkas are small marsupials known as the "happiest animal on Earth". They are native to Western Australia.',
      diet: 'Herbivorous - grasses, leaves, and stems',
      color: Colors.brown.shade100,
      modelUri: 'assets/models/quokka.glb',
    ),
    Animal(
      name: 'Rabbit',
      letter: 'R',
      habitat: 'Various habitats including grasslands and forests',
      description:
          'Rabbits are small mammals known for their long ears and hopping movement. They are found worldwide.',
      diet: 'Herbivorous - grasses, vegetables, and fruits',
      color: Colors.grey.shade200,
      modelUri: 'assets/models/rabbit.glb',
    ),
    Animal(
      name: 'Snake',
      letter: 'S',
      habitat: 'Various habitats worldwide',
      description:
          'Snakes are elongated, limbless reptiles. They are found on every continent except Antarctica.',
      diet: 'Carnivorous - small animals and eggs',
      color: Colors.green.shade100,
      modelUri: 'assets/models/snake.glb',
    ),
    Animal(
      name: 'Tiger',
      letter: 'T',
      habitat: 'Forests and grasslands',
      description:
          'Tigers are the largest wild cats. They are known for their distinctive orange fur with black stripes.',
      diet: 'Carnivorous - deer, wild boar, and other large mammals',
      color: Colors.orange.shade200,
      modelUri: 'assets/models/tiger.glb',
    ),
    Animal(
      name: 'Unicorn',
      letter: 'U',
      habitat: 'Mythical forests',
      description:
          'Unicorns are mythical creatures often depicted as horse-like animals with a single horn on their forehead.',
      diet: 'Mythical - often depicted as eating magical plants',
      color: Colors.purple.shade100,
      modelUri: 'assets/models/unicorn.glb',
    ),
    Animal(
      name: 'Vulture',
      letter: 'V',
      habitat: 'Various habitats including savannas and mountains',
      description:
          'Vultures are large birds of prey that feed primarily on carrion. They play an important role in ecosystems.',
      diet: 'Carnivorous - primarily carrion',
      color: Colors.brown.shade200,
      modelUri: 'assets/models/vulture.glb',
    ),
    Animal(
      name: 'Wolf',
      letter: 'W',
      habitat: 'Forests and tundra',
      description:
          'Wolves are large canines known for their social behavior and hunting skills. They live in packs.',
      diet: 'Carnivorous - large mammals like deer and elk',
      color: Colors.grey.shade300,
      modelUri: 'assets/models/wolf.glb',
    ),
    Animal(
      name: 'Xenopus',
      letter: 'X',
      habitat: 'Freshwater habitats',
      description:
          'Xenopus is a genus of aquatic frogs native to sub-Saharan Africa. They are important in scientific research.',
      diet: 'Carnivorous - insects, small fish, and other aquatic animals',
      color: Colors.green.shade100,
      modelUri: 'assets/models/xenopus.glb',
    ),
    Animal(
      name: 'Yak',
      letter: 'Y',
      habitat: 'High-altitude regions',
      description:
          'Yaks are large, long-haired bovines native to the Himalayas. They are well-adapted to cold climates.',
      diet: 'Herbivorous - grasses and plants',
      color: Colors.brown.shade100,
      modelUri: 'assets/models/yak.glb',
    ),
    Animal(
      name: 'Zebra',
      letter: 'Z',
      habitat: 'African savannas',
      description:
          'Zebras are known for their distinctive black and white striped coats. They are closely related to horses.',
      diet: 'Herbivorous - grasses and leaves',
      color: Colors.grey.shade200,
      modelUri: 'assets/models/zebra.glb',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Animal Encyclopedia'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tap an animal to view details and 3D model',
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
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AnimalDetailScreen(animal: animal),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: animal.color,
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
                          animal.letter,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          animal.name,
                          style: const TextStyle(fontSize: 12),
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

// Animal Detail Screen
class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
        backgroundColor: animal.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal letter and name
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: animal.color,
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
                child: Text(
                  animal.letter,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animal details
            DetailRow(label: 'Name', value: animal.name),
            DetailRow(label: 'Habitat', value: animal.habitat),
            DetailRow(label: 'Diet', value: animal.diet),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              animal.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 32),

            // AR View button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimalARScreen(animal: animal),
                    ),
                  );
                },
                icon: const Icon(Icons.view_in_ar),
                label: const Text('View 3D Model in AR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  const DetailRow({super.key, required this.label, required this.value});

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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// AR Screen for Animals
class AnimalARScreen extends StatefulWidget {
  final Animal animal;

  const AnimalARScreen({super.key, required this.animal});

  @override
  State<AnimalARScreen> createState() => _AnimalARScreenState();
}

class _AnimalARScreenState extends State<AnimalARScreen> {
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
      _debugText =
          "AR View initialized. Tap on a detected plane to place the ${widget.animal.name} model.";
    });

    if (kDebugMode) {
      print("AR Session initialized for ${widget.animal.name}");
    }
  }

  Future<void> _onPlaneOrPointTapped(
      List<ARHitTestResult?> hitTestResults) async {
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
        _debugText = "Surface detected! Placing ${widget.animal.name} model...";
      });

      // Remove existing node if present
      if (_placedNode != null) {
        arObjectManager.removeNode(_placedNode!);
        _placedNode = null;
      }

      try {
        ARNode animalModel = ARNode(
          type: NodeType.localGLTF2,
          uri: widget.animal.modelUri,
          scale: vector_math.Vector3(1.0, 1.0, 1.0),
          transformation: singleHitTestResult.worldTransform,
          name: widget.animal.name,
        );

        bool? didAddNode = await arObjectManager.addNode(animalModel);

        if (didAddNode ?? false) {
          _placedNode = animalModel;
          setState(() {
            _debugText = "${widget.animal.name} model placed successfully!";
            _isModelPlaced = true;
          });

          _showAnimalInfoCard();
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
        _debugText =
            "No valid surface detected. Try tapping on the white dots.";
      });
    }
  }

  void _showAnimalInfoCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.animal.name} - ${widget.animal.habitat}"),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal.name),
        backgroundColor: widget.animal.color,
      ),
      body: Column(
        children: [
          // Debug text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _debugText,
              style: const TextStyle(fontSize: 14, color: Colors.purple),
              textAlign: TextAlign.center,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(widget.animal.name),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.animal.description),
                    const SizedBox(height: 16),
                    const Text("Habitat:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.animal.habitat),
                    const SizedBox(height: 16),
                    const Text("Diet:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.animal.diet),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        tooltip: "Animal Info",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
