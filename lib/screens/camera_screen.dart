import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../models/animal.dart';
import '../widgets/animal_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/animal_details_sheet.dart';

// Main Animal Screen
class ARAnimalsScreen extends StatefulWidget {
  const ARAnimalsScreen({super.key});

  @override
  State<ARAnimalsScreen> createState() => _ARAnimalsScreenState();
}

class _ARAnimalsScreenState extends State<ARAnimalsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Animal> _animals = [
    const Animal(
      name: 'Alligator',
      letter: 'A',
      habitat: 'Freshwater wetlands and swamps',
      description:
          'The American alligator is a large reptile native to the southeastern United States. They are apex predators and play an important role in their ecosystem.',
      diet: 'Fish, birds, mammals, and other reptiles',
      modelUri: 'assets/models/alligator.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Bear',
      letter: 'B',
      habitat: 'Forests and mountains',
      description:
          'Bears are large mammals found across North America, Europe, and Asia. They are known for their strength and intelligence.',
      diet: 'Omnivorous - plants, berries, fish, and small mammals',
      modelUri: 'assets/models/bear.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Cat',
      letter: 'C',
      habitat: 'Domestic and wild environments',
      description:
          'Cats are small, carnivorous mammals that have been domesticated for thousands of years. They are known for their agility and hunting skills.',
      diet: 'Carnivorous - primarily meat',
      modelUri: 'assets/models/cat.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Dog',
      letter: 'D',
      habitat: 'Domestic and wild environments',
      description:
          'Dogs are domesticated mammals and one of the most popular pets worldwide. They are known for their loyalty and intelligence.',
      diet: 'Omnivorous - meat and plant-based foods',
      modelUri: 'assets/models/dog.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Elephant',
      letter: 'E',
      habitat: 'Savannas and forests',
      description:
          'Elephants are the largest land animals on Earth. They are known for their intelligence, memory, and strong social bonds.',
      diet: 'Herbivorous - grasses, leaves, bark, and fruits',
      modelUri: 'assets/models/elephant.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Fox',
      letter: 'F',
      habitat: 'Various habitats including forests and urban areas',
      description:
          'Foxes are small to medium-sized omnivorous mammals. They are known for their cunning and adaptability.',
      diet: 'Omnivorous - small mammals, birds, fruits, and insects',
      modelUri: 'assets/models/fox.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Giraffe',
      letter: 'G',
      habitat: 'African savannas',
      description:
          'Giraffes are the tallest living terrestrial animals. They are known for their long necks and distinctive spotted patterns.',
      diet: 'Herbivorous - leaves, fruits, and flowers from tall trees',
      modelUri: 'assets/models/giraffe.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Hippo',
      letter: 'H',
      habitat: 'Rivers and lakes in Africa',
      description:
          'Hippos are large, mostly herbivorous mammals. Despite their size, they are excellent swimmers.',
      diet: 'Herbivorous - grasses and aquatic plants',
      modelUri: 'assets/models/hippo.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Iguana',
      letter: 'I',
      habitat: 'Tropical forests and deserts',
      description:
          'Iguanas are large lizards native to tropical areas. They are known for their distinctive spines and dewlaps.',
      diet: 'Herbivorous - leaves, flowers, and fruits',
      modelUri: 'assets/models/iguana.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Jaguar',
      letter: 'J',
      habitat: 'Rainforests and grasslands',
      description:
          'Jaguars are the largest cats in the Americas. They are known for their powerful jaws and distinctive spotted coat.',
      diet: 'Carnivorous - deer, peccaries, and other large prey',
      modelUri: 'assets/models/jaguar.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Kangaroo',
      letter: 'K',
      habitat: 'Australian grasslands and forests',
      description:
          'Kangaroos are marsupials native to Australia. They are known for their powerful hind legs and pouches.',
      diet: 'Herbivorous - grasses and plants',
      modelUri: 'assets/models/kangaroo.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Lion',
      letter: 'L',
      habitat: 'African savannas',
      description:
          'Lions are large cats known as the "king of the jungle". They live in social groups called prides.',
      diet: 'Carnivorous - large mammals like zebras and wildebeests',
      modelUri: 'assets/models/lion.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Monkey',
      letter: 'M',
      habitat: 'Tropical forests',
      description:
          'Monkeys are primates known for their intelligence and social behavior. They are found in various habitats worldwide.',
      diet: 'Omnivorous - fruits, leaves, insects, and small animals',
      modelUri: 'assets/models/monkey.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Narwhal',
      letter: 'N',
      habitat: 'Arctic waters',
      description:
          'Narwhals are medium-sized whales known for their long tusks. They are found in Arctic waters.',
      diet: 'Carnivorous - fish, squid, and shrimp',
      modelUri: 'assets/models/narwhal.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Octopus',
      letter: 'O',
      habitat: 'Ocean depths',
      description:
          'Octopuses are highly intelligent invertebrates. They are known for their eight arms and ability to change color.',
      diet: 'Carnivorous - crabs, fish, and other marine animals',
      modelUri: 'assets/models/octopus.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Penguin',
      letter: 'P',
      habitat: 'Antarctic and sub-Antarctic regions',
      description:
          'Penguins are flightless birds adapted to life in water. They are known for their distinctive black and white coloring.',
      diet: 'Carnivorous - fish, squid, and krill',
      modelUri: 'assets/models/penguin.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Quokka',
      letter: 'Q',
      habitat: 'Australian islands',
      description:
          'Quokkas are small marsupials known as the "happiest animal on Earth". They are native to Western Australia.',
      diet: 'Herbivorous - grasses, leaves, and stems',
      modelUri: 'assets/models/quokka.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Rabbit',
      letter: 'R',
      habitat: 'Various habitats including grasslands and forests',
      description:
          'Rabbits are small mammals known for their long ears and hopping movement. They are found worldwide.',
      diet: 'Herbivorous - grasses, vegetables, and fruits',
      modelUri: 'assets/models/rabbit.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Snake',
      letter: 'S',
      habitat: 'Various habitats worldwide',
      description:
          'Snakes are elongated, limbless reptiles. They are found on every continent except Antarctica.',
      diet: 'Carnivorous - small animals and eggs',
      modelUri: 'assets/models/snake.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Tiger',
      letter: 'T',
      habitat: 'Forests and grasslands',
      description:
          'Tigers are the largest wild cats. They are known for their distinctive orange fur with black stripes.',
      diet: 'Carnivorous - deer, wild boar, and other large mammals',
      modelUri: 'assets/models/tiger.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Unicorn',
      letter: 'U',
      habitat: 'Mythical forests',
      description:
          'Unicorns are mythical creatures often depicted as horse-like animals with a single horn on their forehead.',
      diet: 'Mythical - often depicted as eating magical plants',
      modelUri: 'assets/models/unicorn.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Vulture',
      letter: 'V',
      habitat: 'Various habitats including savannas and mountains',
      description:
          'Vultures are large birds of prey that feed primarily on carrion. They play an important role in ecosystems.',
      diet: 'Carnivorous - primarily carrion',
      modelUri: 'assets/models/vulture.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Wolf',
      letter: 'W',
      habitat: 'Forests and tundra',
      description:
          'Wolves are large canines known for their social behavior and hunting skills. They live in packs.',
      diet: 'Carnivorous - large mammals like deer and elk',
      modelUri: 'assets/models/wolf.glb',
      color: Color(0xFFE67E22),
    ),
    const Animal(
      name: 'Xenopus',
      letter: 'X',
      habitat: 'Freshwater habitats',
      description:
          'Xenopus is a genus of aquatic frogs native to sub-Saharan Africa. They are important in scientific research.',
      diet: 'Carnivorous - insects, small fish, and other aquatic animals',
      modelUri: 'assets/models/xenopus.glb',
      color: Color(0xFF34495E),
    ),
    const Animal(
      name: 'Yak',
      letter: 'Y',
      habitat: 'High-altitude regions',
      description:
          'Yaks are large, long-haired bovines native to the Himalayas. They are well-adapted to cold climates.',
      diet: 'Herbivorous - grasses and plants',
      modelUri: 'assets/models/yak.glb',
      color: Color(0xFF2C3E50),
    ),
    const Animal(
      name: 'Zebra',
      letter: 'Z',
      habitat: 'African savannas',
      description:
          'Zebras are known for their distinctive black and white striped coats. They are closely related to horses.',
      diet: 'Herbivorous - grasses and leaves',
      modelUri: 'assets/models/zebra.glb',
      color: Color(0xFFE67E22),
    ),
  ];

  List<Animal> get _filteredAnimals {
    if (_searchQuery.isEmpty) {
      return _animals;
    }
    return _animals.where((animal) {
      return animal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.habitat.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.diet.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAnimalDetails(Animal animal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimalDetailsSheet(
        animal: animal,
        onViewAR: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalARScreen(animal: animal),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A-Z Animal AR Encyclopedia'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          CustomSearchBar(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),

          // Grid of animals
          Expanded(
            child: _filteredAnimals.isEmpty
                ? Center(
                    child: Text(
                      'No animals found',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 16,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredAnimals.length,
                    itemBuilder: (context, index) {
                      final animal = _filteredAnimals[index];
                      return AnimalCard(
                        animal: animal,
                        onTap: () => _showAnimalDetails(animal),
                      );
                    },
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

  Future<void> _forceAddAnimalModel() async {
    if (kDebugMode) {
      print("Forcing animal model placement");
    }

    setState(() {
      _debugText = "Placing ${widget.animal.name} model...";
    });

    if (_placedNode != null) {
      arObjectManager.removeNode(_placedNode!);
      _placedNode = null;
    }

    try {
      final vector_math.Matrix4 fixedTransform = vector_math.Matrix4.identity()
        ..setTranslation(vector_math.Vector3(0, -0.5, -1.0));

      ARNode animalModel = ARNode(
        type: NodeType.localGLTF2,
        uri: widget.animal.modelUri,
        scale: vector_math.Vector3(0.3, 0.3, 0.3),
        transformation: fixedTransform,
        name: widget.animal.name,
      );

      bool? didAddAnimal = await arObjectManager.addNode(animalModel);

      if (didAddAnimal ?? false) {
        _placedNode = animalModel;

        setState(() {
          _debugText = "${widget.animal.name} model placed successfully!";
          _isModelPlaced = true;
        });

        _showAnimalInfoCard();
      } else {
        setState(() {
          _debugText = "Failed to place ${widget.animal.name} model.";
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error placing animal model: $e");
      }
      setState(() {
        _debugText = "Error: $e";
      });
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

    for (var hitResult in hitTestResults) {
      if (hitResult != null && hitResult.type == ARHitTestResultType.plane) {
        singleHitTestResult = hitResult;
        break;
      }
    }

    if (singleHitTestResult != null) {
      setState(() {
        _debugText = "Surface detected! Placing ${widget.animal.name} model...";
      });

      if (_placedNode != null) {
        arObjectManager.removeNode(_placedNode!);
        _placedNode = null;
      }

      try {
        ARNode animalModel = ARNode(
          type: NodeType.localGLTF2,
          uri: widget.animal.modelUri,
          scale: vector_math.Vector3(0.3, 0.3, 0.3),
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
        content: Text("${widget.animal.name} - ${widget.animal.diet}"),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal.name),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Debug text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _debugText,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Note about models
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "AR Animal Viewer",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  "This is a basic AR app that allows you to view 3D models of animals in your environment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.animal.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    "Habitat: ${widget.animal.habitat}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    "Diet: ${widget.animal.diet}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
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
                  title: Text(
                    widget.animal.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.animal.description,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Habitat:",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          widget.animal.habitat,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Diet:",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          widget.animal.diet,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            tooltip: "Animal Info",
            heroTag: "info",
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.info_outline, color: Colors.white),
          ),
          const SizedBox(width: 16),

          // Force place button
          FloatingActionButton(
            onPressed: _forceAddAnimalModel,
            tooltip: "Place Animal Model",
            heroTag: "place",
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add_circle, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
