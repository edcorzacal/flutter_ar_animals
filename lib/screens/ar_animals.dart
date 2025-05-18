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

// Animal Data Model
class Animal {
  final String name;
  final String letter;
  final String habitat;
  final String description;
  final String diet;
  final String modelUri; // URI to 3D model
  final Color color;

  Animal({
    required this.name,
    required this.letter,
    required this.habitat,
    required this.description,
    required this.diet,
    required this.modelUri,
    required this.color,
  });
}

// Main Animal Screen
class AnimalScreen extends StatefulWidget {
  const AnimalScreen({Key? key}) : super(key: key);

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  // A-Z Animals with online 3D models in GLB format
  final List<Animal> animals = [
    Animal(
      name: 'Alligator',
      letter: 'A',
      habitat: 'Freshwater wetlands, marshes, and lakes',
      description:
          'The American alligator is a large reptile native to the southeastern US. It has a broad snout and can grow up to 15 feet long.',
      diet: 'Fish, turtles, birds, and small mammals',
      modelUri: 'assets/models/alligator.glb',
      color: const Color(0xFF2E7D32).withOpacity(0.1), // Updated to match theme
    ),
    Animal(
      name: 'Bear',
      letter: 'B',
      habitat: 'Forests, mountains, and tundra',
      description:
          'Bears are large, powerful mammals found across North America, Europe, and Asia. They have excellent sense of smell and can be dangerous when threatened.',
      diet: 'Omnivore - berries, roots, fish, and small mammals',
      modelUri: 'assets/models/bear.glb',
      color: Colors.brown.shade200,
    ),
    Animal(
      name: 'Cat',
      letter: 'C',
      habitat: 'Domestic and wild environments worldwide',
      description:
          'Cats are small carnivorous mammals known for their agility, sharp retractable claws, and night vision. They have been domesticated for thousands of years.',
      diet: 'Carnivore - small birds, mammals, and commercial cat food',
      modelUri: 'assets/models/cat.glb',
      color: Colors.orange.shade200,
    ),
    Animal(
      name: 'Dog',
      letter: 'D',
      habitat: 'Domestic environments worldwide',
      description:
          'Dogs are domesticated mammals descended from wolves. They are known for their loyalty and have been bred into hundreds of different breeds.',
      diet: 'Omnivore - meat, vegetables, and commercial dog food',
      modelUri: 'assets/models/dog.glb',
      color: Colors.amber.shade200,
    ),
    Animal(
      name: 'Elephant',
      letter: 'E',
      habitat: 'Forests and savannas of Africa and Asia',
      description:
          'Elephants are the largest land animals on Earth. They have long trunks, large ears, and tusks made of ivory.',
      diet: 'Herbivore - grass, leaves, bamboo, bark, and roots',
      modelUri: 'assets/models/elephant.glb',
      color: Colors.grey.shade300,
    ),
    Animal(
      name: 'Fox',
      letter: 'F',
      habitat: 'Forests, grasslands, mountains, and urban areas',
      description:
          'Foxes are small to medium-sized omnivorous mammals with a bushy tail. They are known for their intelligence and adaptability.',
      diet: 'Omnivore - small mammals, birds, fruits, and berries',
      modelUri: 'assets/models/fox.glb',
      color: Colors.deepOrange.shade200,
    ),
    Animal(
      name: 'Giraffe',
      letter: 'G',
      habitat: 'African savannas',
      description:
          'Giraffes are the tallest living terrestrial animals, with distinctive spotted patterns and extremely long necks.',
      diet: 'Herbivore - leaves from tall trees, especially acacia',
      modelUri: 'assets/models/giraffe.glb',
      color: Colors.yellow.shade200,
    ),
    Animal(
      name: 'Hippo',
      letter: 'H',
      habitat: 'Rivers, lakes and mangrove swamps in Africa',
      description:
          'Hippopotamuses are large semi-aquatic mammals with barrel-shaped bodies and large heads. Despite their size, they can be aggressive and dangerous.',
      diet: 'Herbivore - grass and aquatic plants',
      modelUri: 'assets/models/hippo.glb',
      color: Colors.purple.shade200,
    ),
    Animal(
      name: 'Iguana',
      letter: 'I',
      habitat: 'Tropical areas of Mexico, Central America, and the Caribbean',
      description:
          'Iguanas are large lizards with dewlaps and spines running down their backs. They can change color and detach their tails when threatened.',
      diet: 'Herbivore - leaves, flowers, and fruit',
      modelUri: 'assets/models/iguana.glb',
      color: Colors.lightGreen.shade300,
    ),
    Animal(
      name: 'Jaguar',
      letter: 'J',
      habitat: 'Rainforests of Central and South America',
      description:
          'Jaguars are the largest cats in the Americas. They have distinctive spotted coats and are excellent swimmers.',
      diet: 'Carnivore - deer, tapirs, and caiman',
      modelUri: 'assets/models/jaguar.glb',
      color: Colors.amber.shade400,
    ),
    Animal(
      name: 'Kangaroo',
      letter: 'K',
      habitat: 'Australia',
      description:
          'Kangaroos are marsupials known for their powerful hind legs, large feet, and muscular tails. They carry their young in a pouch.',
      diet: 'Herbivore - grass and plants',
      modelUri: 'assets/models/kangaroo.glb',
      color: Colors.brown.shade300,
    ),
    Animal(
      name: 'Lion',
      letter: 'L',
      habitat: 'African savannas and grasslands',
      description:
          'Lions are large cats known as the "king of the jungle." Males have distinctive manes and they live in social groups called prides.',
      diet: 'Carnivore - zebras, wildebeest, and buffalo',
      modelUri: 'assets/models/lion.glb',
      color: Colors.amber.shade300,
    ),
    Animal(
      name: 'Monkey',
      letter: 'M',
      habitat: 'Tropical forests of Africa, Asia, and Central/South America',
      description:
          'Monkeys are intelligent primates with forward-facing eyes and flexible limbs. They live in large social groups.',
      diet: 'Omnivore - fruits, leaves, insects, and small animals',
      modelUri: 'assets/models/monkey.glb',
      color: Colors.brown.shade200,
    ),
    Animal(
      name: 'Narwhal',
      letter: 'N',
      habitat: 'Arctic waters around Greenland, Canada, and Russia',
      description:
          'Often called the "unicorn of the sea," narwhals are known for their long, spiral tusk, which is actually an elongated tooth. They are medium-sized whales that live in pods.',
      diet: 'Carnivore - fish, shrimp, and squid',
      modelUri: 'assets/models/narwhal.glb',
      color: Colors.blue.shade200,
    ),
    Animal(
      name: 'Octopus',
      letter: 'O',
      habitat: 'Oceans worldwide, from coral reefs to deep sea',
      description:
          'Octopuses are highly intelligent marine animals with eight arms, three hearts, and the ability to change color and texture to blend with their surroundings.',
      diet: 'Carnivore - crabs, shrimp, and small fish',
      modelUri: 'assets/models/octopus.glb',
      color: Colors.indigo.shade200,
    ),
    Animal(
      name: 'Penguin',
      letter: 'P',
      habitat: 'Southern Hemisphere, particularly Antarctica',
      description:
          'Penguins are flightless birds highly adapted for life in the water. They have distinctive black and white coloration and walk upright.',
      diet: 'Carnivore - fish, squid, and krill',
      modelUri: 'assets/models/penguin.glb',
      color: Colors.blueGrey.shade300,
    ),
    Animal(
      name: 'Quokka',
      letter: 'Q',
      habitat: 'Small islands off the coast of Western Australia',
      description:
          'Often called the "happiest animal on Earth," quokkas are small marsupials with a distinctive smile-like expression. They are extremely friendly and curious.',
      diet: 'Herbivore - grasses, leaves, and stems',
      modelUri: 'assets/models/quokka.glb',
      color: Colors.brown.shade200,
    ),
    Animal(
      name: 'Rabbit',
      letter: 'R',
      habitat: 'Meadows, woods, forests, grasslands, and wetlands worldwide',
      description:
          'Rabbits are small mammals with powerful hind legs, long ears, and short fluffy tails. They are known for their rapid reproduction and have been domesticated as pets.',
      diet: 'Herbivore - grass, leafy weeds, and vegetables',
      modelUri: 'assets/models/rabbit.glb',
      color: Colors.grey.shade200,
    ),
    Animal(
      name: 'Snake',
      letter: 'S',
      habitat: 'All continents except Antarctica',
      description:
          'Snakes are elongated, legless reptiles with scales. They range from tiny thread snakes to massive pythons and anacondas, with some species being venomous.',
      diet: 'Carnivore - rodents, birds, eggs, and other reptiles',
      modelUri: 'assets/models/snake.glb',
      color: Colors.green.shade300,
    ),
    Animal(
      name: 'Tiger',
      letter: 'T',
      habitat: 'Forests and grasslands of Asia',
      description:
          'Tigers are the largest cat species, known for their powerful build and distinctive orange coat with black stripes. They are solitary and territorial animals.',
      diet: 'Carnivore - deer, wild boar, and other large mammals',
      modelUri: 'assets/models/tiger.glb',
      color: Colors.orange.shade300,
    ),
    Animal(
      name: 'Unicorn',
      letter: 'U',
      habitat: 'Mythical forests and magical realms',
      description:
          'Unicorns are legendary creatures resembling horses with a single horn projecting from their forehead. They symbolize purity and grace in many cultures.',
      diet: 'Herbivore - magical plants, fruits, and berries',
      modelUri: 'assets/models/unicorn.glb',
      color: Colors.pink.shade200,
    ),
    Animal(
      name: 'Vulture',
      letter: 'V',
      habitat: 'Most regions of the world except Australia and Antarctica',
      description:
          'Vultures are large scavenging birds with keen eyesight and mostly bald heads. They play an important role in ecosystems by disposing of carrion.',
      diet: 'Carnivore - carrion (dead animals)',
      modelUri: 'assets/models/vulture.glb',
      color: Colors.blueGrey.shade200,
    ),
    Animal(
      name: 'Wolf',
      letter: 'W',
      habitat:
          'Forests, mountains, tundra, and grasslands of North America and Eurasia',
      description:
          'Wolves are large canines that live and hunt in packs. They have excellent stamina, intelligence, and are known for their howling vocalizations.',
      diet: 'Carnivore - deer, elk, moose, and smaller mammals',
      modelUri: 'assets/models/wolf.glb',
      color: Colors.grey.shade400,
    ),
    Animal(
      name: 'Xenopus',
      letter: 'X',
      habitat:
          'Sub-Saharan Africa, in stagnant pools, and slow-flowing streams',
      description:
          'The Xenopus (African clawed frog) is a species of aquatic frog native to Africa. They have smooth slippery skin and clawed toes on their hind feet.',
      diet: 'Carnivore - insects, small fish, and worms',
      modelUri: 'assets/models/xenopus.glb',
      color: Colors.lightGreen.shade200,
    ),
    Animal(
      name: 'Yak',
      letter: 'Y',
      habitat: 'Himalayan region of southern Central Asia',
      description:
          'Yaks are large, long-haired bovines adapted to high altitudes. They have been domesticated and used as pack animals and for their milk, meat, and wool.',
      diet: 'Herbivore - grasses, herbs, and lichens',
      modelUri: 'assets/models/yak.glb',
      color: Colors.brown.shade400,
    ),
    Animal(
      name: 'Zebra',
      letter: 'Z',
      habitat: 'Eastern and southern Africa',
      description:
          'Zebras are equids known for their distinctive black-and-white striped coats. Each zebra\'s stripe pattern is unique, like a human fingerprint.',
      diet: 'Herbivore - grasses and shrubs',
      modelUri: 'assets/models/zebra.glb',
      color: Colors.grey.shade200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A-Z Animal Encyclopedia'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
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
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Select an animal to view in AR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  final animal = animals[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnimalDetailScreen(animal: animal),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  animal.letter,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    animal.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    animal.habitat,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animal Detail Screen
class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailScreen({Key? key, required this.animal}) : super(key: key);

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
            // Animal symbol and name
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
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
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
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              animal.description,
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
                      builder: (context) => AnimalARScreen(animal: animal),
                    ),
                  );
                },
                icon: const Icon(Icons.view_in_ar),
                label: const Text('View 3D Model in AR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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

  const DetailRow({Key? key, required this.label, required this.value})
      : super(key: key);

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

// AR Screen for Animals
class AnimalARScreen extends StatefulWidget {
  final Animal animal;

  const AnimalARScreen({Key? key, required this.animal}) : super(key: key);

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

  // Place the animal model at a fixed position
  Future<void> _forceAddAnimalModel() async {
    if (kDebugMode) {
      print("Forcing animal model placement");
    }

    setState(() {
      _debugText = "Placing ${widget.animal.name} model...";
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

      ARNode animalModel = ARNode(
        type: NodeType.localGLTF2, // Using local GLTF/GLB model type
        uri: widget.animal.modelUri,
        scale: vector_math.Vector3(0.3, 0.3, 0.3), // Scaled to be visible
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

        // Show animal information
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

    // Find the first plane hit test result
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

      // Remove existing node if present
      if (_placedNode != null) {
        arObjectManager.removeNode(_placedNode!);
        _placedNode = null;
      }

      try {
        ARNode animalModel = ARNode(
          type: NodeType.localGLTF2, // Using local GLTF/GLB model type
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
    // Show a simple overlay with animal information
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
        backgroundColor: widget.animal.color,
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
                  "AR Animal Viewer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "This is a basic AR app made by Group 4 that allows you to view 3D models of animals in your environment.",
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
                color: widget.animal.color.withOpacity(0.8),
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
                    widget.animal.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Habitat: ${widget.animal.habitat}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Diet: ${widget.animal.diet}",
                    style: TextStyle(fontSize: 14),
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
                  title: Text(widget.animal.name),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.animal.description),
                        const SizedBox(height: 16),
                        Text("Habitat:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.animal.habitat),
                        const SizedBox(height: 16),
                        Text("Diet:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.animal.diet),
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
            tooltip: "Animal Info",
            heroTag: "info",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 16),

          // Force place button
          FloatingActionButton(
            onPressed: _forceAddAnimalModel,
            tooltip: "Place Animal Model",
            heroTag: "place",
            backgroundColor: Colors.green,
            child: const Icon(Icons.add_circle),
          ),
        ],
      ),
    );
  }
}
