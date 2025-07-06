//
//  GameSections.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/21/25.
//

class GameSections {
    
    static let all: [Section] = [
        sectionIntro,
        firstDiet,
        secondIsland,
        thirdSidewalk,
        sectionOutro
    ]
        
    static let sectionIntro = Section(
        title: "Introduction",
        dialogs: [
            Message(
                elements: [
                    DialogLogo("""
                    
                    
                    
                    
                    
                    
                     _       __            ____                        
                    | |     / /___ ___  __/ __/___ _________  _____    
                    | | /| / / __ `/ / / / /_/ __ `/ ___/ _ \\/ ___/    
                    | |/ |/ / /_/ / /_/ / __/ /_/ / /  /  __/ /        
                    |__/|__/\\__,_/\\__, /_/  \\__,_/_/___\\___/_/__  ____ 
                                 /____/           <  / __ \\/ __ \\/ __ \\
                                                  / / / / / / / / / / /
                                                 / / /_/ / /_/ / /_/ / 
                                                /_/\\____/\\____/\\____/  
                    
                    
                    
                    
                    
                    """)
                ],
                controls: .custom("""
                
                [ENTER] to START
                
                """, .center)
            ),
            Message(
                elements: [
                    DialogText("Take the time to familiarize yourself with the device."),
                    DialogText("You’re looking at the Console screen, where all the instructions will be shown."),
                    DialogText("On the left is the Game screen, where your puzzles will be shown."),
                    DialogText("Below the Console are the control keys. From left to right you have [SETTINGS], [UP], [DOWN], and [ENTER].")
                ],
                controls: .continueOnly
            ),
            Message(
                elements: [
                    DialogText("The goal of the game is simple: Make pedestrians safe."),
                    DialogText("As the city's new urban planner, your job is to rehabilitate the city to make it pedestrian-safe."),
                    DialogText("There are a total of 3 levels, and you need to solve a puzzle to beat each level. Each level gives you everything you need to know to solve it."),
                    DialogText("Before we get started, let's try out a practice level.")
                ],
                controls: .continueOnly
            ),
            Puzzle(
                elements: [
                    DialogText("PRACTICE LEVEL", fontWeight: .bold),
                    DialogText("""
                    The path that people walk on by the road is called a...
                    """),
                    PuzzleOptions()
                ],
                sprites: [
                    "prac_1",
                    "prac_2",
                    "prac_3",
                    "prac_4",
                    "prac_5"
                ],
                choices: [
                    "Lane",
                    "Sidewalk",
                    "Driveway"
                ],
                correctIndex: 1
            ),
            Message(
                elements: [
                    DialogText("""
                    Nice work! Here's a few more things to know before you finally start.
                    """),
                    DialogText("""
                    You may have noticed that so far you can only continue through the dialogs, but before each puzzle, you can use the [UP] and [DOWN] keys to navigate through pages.
                    """),
                    DialogText("""
                    If you get stuck on a level, shake the device to reset that level. Try to do it sparingly though!
                    """)
                ],
                controls: .continueOnly
            )
        ]
    )
    
    static let firstDiet = Section(
        title: "Road Diet",
        dialogs: [
            Message(
                elements: [
                    DialogText("""
                    LEVEL 1: ROAD DIETS
                    """, fontWeight: .bold),
                    DialogText("""
                    Lanes guide vehicles and organize traffic flow, but problems can arise when pedestrians aren't taken into account.
                    """),
                    DialogText("""
                    Wide lanes encourage speeding, and numerous lanes can create long, dangerous crossing distances for pedestrians.
                    """),
                    DialogText("""
                    Drivers often weave through these roads at high speeds and put pedestrians at a greater risk of collision.
                    """),
                ],
                controls: .firstPage
            ),
            Message(
                elements: [
                    DialogText("""
                    One solution to this problem is to reduce the number of lanes, this is called a "road diet".
                    """),
                    DialogText("""
                    A typical 4-lane road layout would be reduced to 3 lanes, one for each direction and a shared lane for turning. This shortens the distance pedestrians have to cross, making it much safer.
                    """),
                    DialogText("""
                    Less lanes means drivers move at slower speeds, meaning the risk of vehicle and pedestrian collisions are lower. The Department of Transportation found that road diets reduce crashes by 19-47%.
                    """)
                ],
                controls: .middlePage,
                sprites: [
                    "level1_diet"
                ]
            ),
            Message(
                elements: [
                    DialogText("""
                    The space saved from removing lanes can be used to add bike lanes, parking spaces, or wider sidewalks.
                    """),
                    DialogText("""
                    Another benefit is that it is cost effective, only requiring restriping and making new signage.
                    """)
                ],
                controls: .lastPage,
                sprites: [
                    "level1_diet"
                ]
            ),
            Puzzle(
                elements: [
                    DialogText("LEVEL 1", fontWeight: .bold),
                    DialogText("""
                    The streets along a bustling downtown area with heavy foot traffic underwent a road diet. Which of these would be the best use for the extra space?
                    """),
                    PuzzleOptions()
                ],
                sprites: [
                    "level1_puzzle1",
                    "level1_puzzle2"
                ],
                choices: [
                    "Wider sidewalks",
                    "Parking lane",
                    "Bike lane"
                ],
                correctIndex: 0
            ),
            Message(
                elements: [
                    DialogText("""
                    Awesome! That wasn't so hard, was it?
                    """),
                    DialogText("""
                    If you were choosing between a wider sidewalk and a bike lane, remember that the wider sidewalks can acommodate the heavy foot traffic.
                    """),
                    DialogText("""
                    In the next level, we'll talk about another solution to lanes: median islands.
                    """)
                ],
                controls: .continueOnly
            ),
        ]
    )
    
    static let secondIsland = Section(
        title: "Median Islands",
        dialogs: [
            Message(
                elements: [
                    DialogText("""
                    LEVEL 2: MEDIAN ISLANDS
                    """, fontWeight: .bold),
                    DialogText("""
                    In the previous level, we talked about road diets. While road diets are more suitable for roads with moderate traffic, they might not be suitable for busier areas.
                    """),
                    DialogText("""
                    In such cases, median islands offer a better solution. These are physical barriers that divide the road into two. They provide a safe space in for pedestrians to wait when crossing.
                    """),
                    DialogText("""
                    The DOT has found that adding median islands reduce pedestrian accidents by 46-56%.
                    """)
                ],
                controls: .firstPage,
                sprites: [
                    "level2_median1",
                    "level2_median2"
                ]
            ),
            Message(
                elements: [
                    DialogText("""
                    They can vary in size and shape. Larger islands can be used to beautify the area with trees and plants and they provide an additional barrier for vehicles, shade for pedestrians waiting, and reduces noise pollution.
                    """),
                    DialogText("""
                    They can also be used in conjunction with road diets. A 6-lane road can be rearranged to have 4 active lanes and 2 parking lanes, with a median island in between. The sidewalk extends to the median island, reducing the crossing distance further. 
                    """)
                ],
                controls: .lastPage,
                sprites: [
                    "level2_sixlane1",
                    "level2_sixlane2"
                ]
            ),
            Puzzle(
                elements: [
                    DialogText("LEVEL 2", fontWeight: .bold),
                    DialogText("""
                    The city wants to maximize the safety of the median islands, but cannot remove any more lanes. Which of these is the best option to add on the islands? (Hint: Look closely!)
                    """),
                    PuzzleOptions()
                ],
                sprites: [
                    "level2_puzzle1"
                ],
                choices: [
                    "Widening the islands",
                    "Trees",
                    "Art installations"
                ],
                correctIndex: 1
            ),
            Message(
                elements: [
                    DialogText("""
                    You're doing great!
                    """),
                    DialogText("""
                    Widening the island would be a good choice if there was space, so the best option is to add trees. Remember that trees can also act as barriers that divide opposing traffic.
                    """),
                    DialogText("""
                    The next level is the last. You can do it!
                    """)
                ],
                controls: .continueOnly
            ),
        ]
    )
    
    static let thirdSidewalk = Section(
        title: "Sidewalks",
        dialogs: [
            Message(
                elements: [
                    DialogText("Level 3: Sidewalks", fontWeight: .bold),
                    DialogText("""
                    Sidewalks are an essential part of urban infrastructure. They provide dedicated spaces for walking, ensuring that pedestrians, including those with disabilities, have safe and convenient routes.
                    """),
                    DialogText("""
                    Because of car-dependent infrastructure, many roads have unsafe sidewalks. Some roads don't have sidewalks at all, forcing pedestrians to walk on the sides of the roads and put themselves in danger especially at high-traffic areas.
                    """)
                ],
                controls: .firstPage,
                sprites: [
                    "level3_sidewalk1",
                    "level3_sidewalk2",
                    "level3_sidewalk3"
                ]
            ),
            Message(
                elements: [
                    DialogText("""
                    The DOT reports that sidewalks reduces pedestrian crashes along roadways by 65-89%
                    """),
                    DialogText("""
                    Not only is adding sidewalks important, so is ensuring that it is well-designed. They should be wide enough and has ramps to acommodate people in wheelchairs and that it keeps a safe distance from the road.
                    """),
                    DialogText("""
                    Similar to median islands, trees and plants can be used as a barrier between the sidewalk and the road.
                    """)
                ],
                controls: .middlePage,
                sprites: [
                    "level3_sidewalk1",
                    "level3_sidewalk2",
                    "level3_sidewalk3"
                ]
            ),
            Message(
                elements: [
                    DialogText("""
                    In areas with low pedestrian traffic, where building sidewalks might not be practical, paved shoulders can be used. Think of it as an extra lane for pedestrians and cyclists.
                    """),
                    DialogText("""
                    Road bumps can be used to prevent cars from accidentally driving on paved shoulders and to visually separate them.
                    """),
                    DialogText("""
                    The DOT found that paved shoulders reduces pedestrian crashes along roadways by 71%
                    """)
                ],
                controls: .lastPage,
                sprites: [
                    "level3_paved"
                ]
                    
            ),
            Puzzle(
                elements: [
                    DialogText("LEVEL 3: PART 1", fontWeight: .bold),
                    DialogText("""
                    A suburban road has bus stops on both sides, but pedestrians struggle to cross safely due to high traffic and fast-moving vehicles. What's missing from the road?
                    """),
                    PuzzleOptions()
                ],
                sprites: [
                    "level3_puzzle1"
                ],
                choices: [
                    "Pedestrian crossing and signage",
                    "Underground pedestrian tunnel",
                    "Nothing's missing"
                ],
                correctIndex: 0
            ),
            Puzzle(
                elements: [
                    DialogText("LEVEL 3: PART 2", fontWeight: .bold),
                    DialogText("""
                    The bus stop sits dangerously close to the road, leaving waiting passengers with no protection from the vehicles. What would be the best thing to add?
                    """),
                    PuzzleOptions()
                ],
                sprites: [
                    "level3_puzzle2"
                ],
                choices: [
                    "Pull-out lane for the bus to stop",
                    "Wide sidewalk",
                    "Both of the above"
                ],
                correctIndex: 2
            )
        ]
    )
    
    static let sectionOutro = Section(
        title: "Outro",
        dialogs: [
            Message(
                elements: [
                    DialogLogo("""
                    
                    
                     _    ___      __                   __
                    | |  / (_)____/ /_____  _______  __/ /
                    | | / / / ___/ __/ __ \\/ ___/ / / / / 
                    | |/ / / /__/ /_/ /_/ / /  / /_/ /_/  
                    |___/_/\\___/\\__/\\____/_/   \\__, (_)   
                                              /____/      
                    
                    
                    
                    """),
                    DialogText("""
                    You finished the game, but the fight for pedestrian safety isn't over yet. There's lots more we can do.
                    """, alignment: .center),
                    DialogText("""
                    Thanks for playing! If you want to play again, press the [SETTINGS] key.
                    """, alignment: .center)
                ],
                controls: .custom("", .center),
                sprites: [
                    "level3_puzzle3"
                ]
            )
        ]
    )
}

