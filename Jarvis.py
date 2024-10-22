from datetime import datetime
import speech_recognition as sr
import pyttsx3, random, time, webbrowser ,pyautogui, os, sys

# Initialize the speech engine
engine = pyttsx3.init()

def speak(text):
    """Convert text to speech."""
    engine.say(text)
    engine.runAndWait()

def get_weather():
    """Open the browser to display today's weather."""
    search_query = "weather today"
    search_url = f"https://www.google.com/search?q={search_query}"
    webbrowser.open(search_url)
    speak("Opening your browser to check the weather. Please check the browser for details.")
jokes = [
    "Why don't scientists trust atoms? Because they make up everything!",
    "Why did the scarecrow win an award? Because he was outstanding in his field!",
    "Why did the bicycle fall over? Because it was two-tired!",
    "What do you call fake spaghetti? An impasta!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call cheese that isn't yours? Nacho cheese!",
    "How does a penguin build its house? Igloos it together!",
    "What do you get when you cross a snowman and a vampire? Frostbite!",
    "Why was the math book sad? Because it had too many problems!",
    "Why don't programmers like nature? It has too many bugs!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why did the golfer bring two pairs of pants? In case he got a hole in one!",
    "What did one ocean say to the other ocean? Nothing, they just waved!",
    "Why did the tomato turn red? Because it saw the salad dressing!",
    "How does a snowman get around? By riding an 'icicle'!",
    "What do you call a dinosaur with an extensive vocabulary? A thesaurus!",
    "Why did the coffee file a police report? It got mugged!",
    "What do you call a pile of cats? A meowtain!",
    "What do you get when you cross a snake and a pie? A python!",
    "Why did the math teacher break up with the calculator? It couldn't count on it!",
    "What do you call an alligator in a vest? An investigator!",
    "How does a vampire start a letter? Tomb it may concern!",
    "Why don't programmers like to go outside? The sunlight causes too many errors!",
    "What do you call a fish wearing a bowtie? Sofishticated!",
    "Why did the computer go to the doctor? Because it had a virus!",
    "How do you organize a space party? You planet!",
    "Why did the bicycle stand up by itself? It was two-tired!",
    "What do you get if you cross a cat with a dark horse? Kitty Perry!",
    "Why don't ants get sick? Because they have tiny ant-bodies!",
    "What do you call a lazy kangaroo? A pouch potato!",
    "Why don't some couples go to the gym? Because some relationships don't work out!",
    "What did the grape do when it got stepped on? Nothing but let out a little wine!",
    "What did one wall say to the other wall? I'll meet you at the corner!",
    "Why did the student eat his homework? Because his teacher told him it was a piece of cake!",
    "How do cows stay up to date with current events? They read the moos-paper!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the chicken join a band? Because it had the drumsticks!",
    "What's orange and sounds like a parrot? A carrot!",
    "What do you call a fish with no eyes? Fsh!",
    "Why don't scientists trust atoms? Because they make up everything!",
    "What's brown and sticky? A stick!",
    "Why was the math book unhappy? It had too many problems!",
    "What do you call an elephant that doesn't matter? An irrelephant!",
    "How do you catch a squirrel? Climb a tree and act like a nut!",
    "Why did the scarecrow become a successful neurosurgeon? Because he was outstanding in his field!",
    "What do you call a factory that makes good products? A satisfactory!",
    "Why did the physics professor break up with the biology professor? There was no chemistry!",
    "What did the janitor say when he jumped out of the closet? Supplies!",
    "Why did the golfer bring an extra pair of pants? In case he got a hole in one!",
    "What do you call a bear that's stuck in the rain? A drizzly bear!",
    "What do you call a snowman with a six-pack? An abdominal snowman!",
    "Why did the banker switch careers? He lost interest!",
    "What's a vampire's favorite fruit? A necktarine!",
    "What kind of music do mummies listen to? Wrap music!",
    "What do you call a dinosaur that is sleeping? A dino-snore!",
    "How do you make a tissue dance? You put a little boogie in it!",
    "Why did the cookie go to the hospital? Because it felt crummy!",
    "What do you call a can opener that doesn't work? A can't opener!",
    "Why did the chicken go to the séance? To talk to the other side!",
    "What did the fisherman say to the magician? Pick a cod, any cod!",
    "Why don't skeletons fight each other? They don't have the guts!"
]

def tell_joke():
    """Tell a random joke from the jokes list."""
    if not jokes:
        speak("Hmm, sorry sir, I do not know any more jokes as of now.")
    else:
        joke = random.choice(jokes)
        speak(joke)
        jokes.remove(joke)

def play_music():
    """Open Spotify in the browser."""
    url = "https://open.spotify.com"
    webbrowser.open(url)
    speak("Opening Spotify in your browser. Please hit play.")

def set_reminder(minutes, message):
    """Set a reminder after a specified number of minutes."""
    speak(f"Setting a reminder for {minutes} minutes from now.")
    time.sleep(minutes * 60)
    speak(f"Reminder: {message}")

def get_date_time():
    """Speak the current date and time."""
    now = datetime.now()
    return now.strftime("Today is %A, %B %d, %Y. The current time is %I:%M %p.")

def search_and_speak(query):
    # """Search the web and inform the user."""
    # search_url = f"https://www.google.com/search?q={query}"
    # webbrowser.open(search_url)
    # speak("Here's what I found on the web!")
    webbrowser.open(f"https://chatgpt.com/")
    # type the query using keyboard
    time.sleep(5)
    pyautogui.write(query, interval=0.07)
    pyautogui.press('enter')
    speak("here you go sir.")
def open_app(app_name):
    """Open specified applications."""
    app_name = app_name.lower()
    pyautogui.press('win')
    pyautogui.write(app_name)
    pyautogui.press('enter')
    speak(f"Opening {app_name}.")
def close_app(app_name):
    try:
        # Locate the application window and bring it to the foreground
        window = pyautogui.getWindowsWithTitle(app_name)
        if window:
            window[0].activate()  # Bring the application window to the front
            time.sleep(0.5)  # Wait a moment for the window to activate
            pyautogui.hotkey('alt', 'f4')  # Simulate Alt + F4 to close the window
            print(f"{app_name} has been closed.")
        else:
            print(f"{app_name} not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
import psutil  # Make sure to install this library

def BatteryChecker():
    # Get battery information
    battery = psutil.sensors_battery()
    
    if battery is not None:
        # Extract the battery percentage
        percent = battery.percent
        # Check if the device is plugged in
        plugged = battery.power_plugged
        
        # Create the message to speak
        if plugged:
            message = f"The battery is currently at {percent} percent and the device is plugged in."
        else:
            message = f"The battery is currently at {percent} percent and the device is not plugged in."
        
        # Use your custom speak function to say the message
        speak(message)
    else:
        speak("Sorry, I couldn't detect the battery status.")

    pyautogui.press('backspace')
    return True


import threading
def jarvis_command_handler():
    """Listen for commands after the wake-up phrase is detected."""
    recognizer = sr.Recognizer()
    mic = sr.Microphone()

    with mic as source:
        print("Listening for wake-up phrases...")
        recognizer.adjust_for_ambient_noise(source)
        audio = recognizer.listen(source)

    try:
        command = recognizer.recognize_google(audio).lower()
        print(f"Recognized command: {command}")

        if "jarvis" in command or "hey jarvis" in command:
            speak("Yes sir, i'm here. ")
            speak("What can I do for you?")

            with mic as source:
                recognizer.adjust_for_ambient_noise(source)
                audio2 = recognizer.listen(source)

            try:
                command2 = recognizer.recognize_google(audio2).lower()
                print(f"Recognized command: {command2}")
                if "time" in command2:
                    current_time = datetime.now().strftime("%I:%M %p")
                    speak(f"The current time is {current_time}.")
                    return True
                elif ("what is today's date" or "what is the date today") in command2:
                    date_time_info = get_date_time()
                    speak(date_time_info)
                    return True
                elif "weather" in command2:
                    get_weather()
                    return True
                # elif ("battery level" or "battery percentage") in command2:
                #     BatteryChecker()
                #     return True
                elif any(phrase in command2 for phrase in ["what all can you do", "what can you do jarvis", "what can you do"]):
                    speak("I can do various things like:")
                    speak("Tell you the current time.")
                    speak("Give you the current weather.")
                    speak("Open certain apps.")
                    speak("Go to desktop.")
                    speak("Lock your computer.")
                    speak("Shut down the computer.")
                    speak("Tell you a joke.")
                    speak("Play a song for you on Spotify.")
                    speak("Or even set a reminder.")
                    speak("You just have to say my name. I'm here. Just say, Jarvis or, Hey Jarvis.")
                    return True
                elif "open" in command2:
                    app_name = command2.replace("open", "").strip()
                    open_app(app_name)
                    return True
                elif "close" in command2:
                    app_name = command2.replace("close", "").strip()
                    close_app(app_name)
                    return True
                elif "send a message" in command2:
                    speak("Certainly sir, please tell me the messsage.")
                    with mic as source:
                        recognizer.adjust_for_ambient_noise(source)
                        audio6 = recognizer.listen(source)
                    TextMessage = recognizer.recognize_google(audio6).lower()
                    print("Your text message : ",TextMessage)
                    speak('Got it sir !')
                    pyautogui.press('win')
                    pyautogui.write(" Whatsapp",interval=0.1)
                    pyautogui.press('enter')
                    pyautogui.hotkey('ctrl','f')
                    speak("who would you like to send a message to ?")
                    with mic as source:
                        recognizer.adjust_for_ambient_noise(source)
                        audio5 = recognizer.listen(source)
                    MessagePerson = recognizer.recognize_google(audio5).lower()
                    speak("sure sir , messaging {}".format(MessagePerson))
                    pyautogui.write(MessagePerson)
                    pyautogui.press('tab') 
                    pyautogui.press('enter')
                    pyautogui.click(x=713, y=1050)
                    pyautogui.click(x=713, y=1050)
                    pyautogui.click(x=713, y=1050)
                    pyautogui.click(x=713, y=1050)
                    
                    
                    pyautogui.write(TextMessage, interval=0.2)
                    speak("Hope the message is okay sir. If it's not, you have 15 seconds , to change the message.")
                    for i in range(15, 0, -1):
                        speak(str(i))
                    # speak("Is the message okay sir ? Please answer in yes or no")
                    # with mic as source:
                    #     recognizer.adjust_for_ambient_noise(source)
                    #     audio7 = recognizer.listen(source)
                    # OkayOrNot = recognizer.recognize_google(audio7).lower()
                    # if "no" or "not okay" in OkayOrNot:
                    #     speak("Sorry sir, please type the message manually as there was some error while sending the message to {}".format(MessagePerson))
                    # else:
                    pyautogui.press('enter')
                    speak("Message sent to, {} at ,{}".format(MessagePerson,datetime.now().strftime("%H:%M:%S")))
                    return True
                # elif "start typing":
                #     speak("Okay sir, I am ready to type for you. Please tell me what to type.")
                #     with mic as source:
                #         recognizer.adjust_for_ambient_noise(source)
                #         audio8 = recognizer.listen(source)
                #     TextToType = recognizer.recognize_google(audio8).lower()
                #     pyautogui.write(TextToType)
                #     return True
                # elif "hit enter":
                #     pyautogui.press('enter')
                #     return True
                # elif "decrease the volume" or "decrease volume" in command2:
                #     decreaseVol()
                #     return True
                # elif "mute" in command2:
                #     muter()
                #     return True

                elif "shutdown" in command2 or "power off" in command2:
                    speak("Shutting down the computer in t-")
                    for i in range(10, 0, -1):
                        speak(str(i))
                    os.system('shutdown /s /t 02')
                    return True

                elif "joke" in command2:
                    tell_joke()
                    return True
                elif "iron man" in command2:
                    speak("Certainly sir.")
                    try: 
                        IronManMaker()
                    except Exception as e:
                        speak("Sorry , something went wrong while making iron man")
                    return True
                elif "play music" in command2 or "play song" in command2:
                    play_music()
                    return True
                elif any(phrase in command2 for phrase in ["how","who","what","when","name the","tell","explain"]):
                    search_and_speak(command2)
                    return True
                elif "reminder" in command2:
                    speak("Sure sir, what would you like me to remind you of?")
                    speak("Please tell me the message.")

                    with mic as source:
                        recognizer.adjust_for_ambient_noise(source)
                        audio3 = recognizer.listen(source)

                    reminder_message = recognizer.recognize_google(audio3).lower()

                    speak("Got it sir! Can you please specify the time duration in minutes?")

                    with mic as source:
                        recognizer.adjust_for_ambient_noise(source)
                        audio4 = recognizer.listen(source)

                    try:
                        minutes = int(''.join(filter(str.isdigit, recognizer.recognize_google(audio4))))
                        set_reminder(minutes, reminder_message)
                        speak("Reminder set successfully.")
                    except ValueError:
                        speak("I couldn't understand the time duration. Please try again.")

                    return True
                elif any(phrase in command2 for phrase in ["bye", "goodbye", "see you later", "adios"]):
                    speak("Goodbye Sir! If you want to talk again, please say my name, I'm here!")
                    speak("Have a nice day, sir!")
                    sys.exit(0)

                # elif "start hand tracker" or "activate hand tracker" in command2:
                #     speak("Starting hand tracker.")
                #     speak("if you wish to talk with me again, just show all five fingers to stop hand tracker .")
                #     HandTracker()
                #     return True
                else:
                    search_and_speak(command2)
                    return True

            except sr.UnknownValueError:
                speak("Sorry, I did not understand that command.")
                return False

            except sr.RequestError:
                speak("Sorry, there was an issue with the speech recognition service.")
                return False

        else:
            return False

    except sr.UnknownValueError:
        # No wake-up phrase detected; continue listening
        return False

    except sr.RequestError:
        speak("Sorry, there was an issue with the speech recognition service.")
        return False

def IronManMaker():
    import turtle
    piece1=[[(-40, 120), (-70, 260), (-130, 230), (-170, 200), (-170, 100), (-160, 40), (-170, 10), (-150, -10), (-140, 10), (-40, -20), (0, -20)],[(0, -20), (40, -20), (140, 10), (150, -10), (170, 10), (160, 40), (170, 100), (170, 200), (130, 230), (70, 260), (40, 120), (0, 120)]]
    piece2=[[(-40, -30), (-50, -40), (-100, -46), (-130, -40), (-176, 0), (-186, -30), (-186, -40), (-120, -170), (-110, -210), (-80, -230), (-64, -210), (0, -210)],[(0, -210), (64, -210), (80, -230), (110, -210), (120, -170), (186, -40), (186, -30), (176, 0), (130, -40), (100, -46), (50, -40), (40, -30), (0, -30)]]
    piece3=[[(-60, -220), (-80, -240), (-110, -220), (-120, -250),(-90, -280), (-60, -260), (-30, -260), (-20, -250), (0, -250)],[(0, -250), (20, -250), (30, -260), (60, -260), (90, -280), (120, -250),(110, -220), (80, -240), (60, -220), (0, -220)]]
    turtle.hideturtle()
    turtle.bgcolor('black')
    turtle.setup(500,600)
    turtle.title("Ironman")
    piece1Goto=(0,120)
    piece2Goto=(0,-30)
    piece3Goto=(0,-220)
    turtle.speed(2)
    def draw_piece(piece,pieceGoto):
        turtle.penup()
        turtle.goto(pieceGoto)
        turtle.pendown()
        turtle.color('red')
        turtle.begin_fill()
        for i in range(len(piece[0])):
            x,y=piece[0][i]
            turtle.goto(x,y)
        
        for i in range(len(piece[1])): 
            x,y=piece[1][i]
            turtle.goto(x,y)
        turtle.end_fill()
    draw_piece(piece1,piece1Goto)
    draw_piece(piece2,piece2Goto)
    draw_piece(piece3,piece3Goto)
    
def SoundTrack():
    import wave
    import pyaudio

    def play_wav(file_path):
        chunk = 1024
        wf = wave.open(file_path, 'rb')
        p = pyaudio.PyAudio()

        stream = p.open(format=p.get_format_from_width(wf.getsampwidth()),
                        channels=wf.getnchannels(),
                        rate=wf.getframerate(),
                        output=True)

        data = wf.readframes(chunk)

        while data:
            stream.write(data)
            data = wf.readframes(chunk)

        stream.stop_stream()
        stream.close()
        p.terminate()

    # Example usage
    # play_wav('WelcomeBackJarvis.wav') put path here
  
# IronManMaker()
def main():
    # speak("Welcome back  sir. Hope you're having a good day.")
    SoundTrack()
    speak('Jarvis, is ,loading ')
    import turtle
    screen = turtle.Screen()
    screen.bgcolor("black")
    # screen.bgpic('JARVIS_ICON.gif') put your path here 
    pen = turtle.Turtle()
    pen.speed(10)  # Set speed to 8 for faster drawing
    pen.showturtle()  # Show the turtle pointer
    def draw_circle_with_border(radius, fill_color, outline_width=1):
        pen.penup()
        pen.goto(0, -radius)  # Move turtle to starting point of circle
        pen.pendown()
        pen.pensize(outline_width)
        pen.color("black")
        pen.circle(radius)
        # Draw filled circle inside
        pen.penup()
        pen.goto(0, -radius)  # Move turtle to starting point of circle
        pen.pendown()
        pen.pensize(outline_width)
        pen.color("black", fill_color)  # Set black outline and fill color
        pen.begin_fill()
        pen.circle(radius)
        pen.end_fill()
    def draw_inverted_triangle_with_border(size, fill_color, y_offset):
        pen.penup()
        pen.goto(-size / 2, size / 2 - y_offset)  # Adjust the position for the y_offset
        pen.setheading(-60)  # Angle for inverted triangle
        pen.pendown()
        pen.color("black")
        for _ in range(3):
            pen.forward(size)
            pen.left(120)
        pen.penup()
        pen.goto(-size / 2, size / 2 - y_offset)  # Adjust the position for the y_offset
        pen.setheading(-60)  # Angle for inverted triangle
        pen.pendown()
        pen.color("black", fill_color)
        pen.begin_fill()
        for _ in range(3):
            pen.forward(size)
            pen.left(120)
        pen.end_fill()
    draw_circle_with_border(100, "navy", outline_width=1)  # Large circle, filled with navy dark blue
    draw_circle_with_border(60, "lightgrey", outline_width=8)  # Smaller circle with thicker border
    pen.setheading(0)  # Reset turtle heading
    i=0
    while i!=90:
        draw_inverted_triangle_with_border(80, "lightskyblue", y_offset=10)  # Triangle moved higher
        if i==10 or i==50 or i==80: speak("Loading Jarvis. {}percent loaded".format(i))
        i+=10
    draw_inverted_triangle_with_border(80, "red", y_offset=10)  # Triangle moved higher
    speak("Jarvis is ready")
    speak("Please close the window to get started.")
    pen.hideturtle()
    screen.mainloop()
    counter=0
    while True:
        if counter==0: 
            speak("Just say , jarvis or , hey jarvis to start")
            counter+=1
        jarvis_command_handler()
if __name__ == "__main__":
    main()
