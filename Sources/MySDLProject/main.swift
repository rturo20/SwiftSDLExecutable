import SDLWrapper
import Foundation

// Initialize SDL
guard SDLWrapper.initialize() else {
    fatalError("Could not initialize SDL: \(SDLWrapper.getError())")
}

// Create window
guard let window = SDLWrapper.createWindow(
    title: "Interactive Cat Drawing",
    x: SDLWrapper.SDL_WINDOWPOS_UNDEFINED,
    y: SDLWrapper.SDL_WINDOWPOS_UNDEFINED,
    w: 800,
    h: 600,
    flags: SDLWrapper.SDL_WINDOW_SHOWN
) else {
    fatalError("Could not create window: \(SDLWrapper.getError())")
}

// Create renderer with hardware acceleration
guard let renderer = SDLWrapper.createRenderer(window: window, index: -1, flags: SDLWrapper.SDL_RENDERER_ACCELERATED) else {
    fatalError("Could not create renderer: \(SDLWrapper.getError())")
}

// Function to draw a filled circle
func drawFilledCircle(renderer: OpaquePointer?, centerX: Int32, centerY: Int32, radius: Int32, r: UInt8, g: UInt8, b: UInt8) {
    if SDLWrapper.setRenderDrawColor(renderer, r: r, g: g, b: b, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
        return
    }
    
    for w in -radius...radius {
        for h in -radius...radius {
            if (w * w + h * h) <= (radius * radius) {
                if SDLWrapper.renderDrawPoint(renderer, x: centerX + w, y: centerY + h) < 0 {
                    print("Warning: Failed to draw point: \(SDLWrapper.getError())")
                }
            }
        }
    }
}

// Function to draw the scene
func drawScene(mouseX: Int32, mouseY: Int32) {
    // Clear screen with white background
    if SDLWrapper.setRenderDrawColor(renderer, r: 255, g: 255, b: 255, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
    }
    if SDLWrapper.renderClear(renderer) < 0 {
        print("Warning: Failed to clear renderer: \(SDLWrapper.getError())")
    }
    
    // Draw decorative background pattern using lines
    if SDLWrapper.setRenderDrawColor(renderer, r: 230, g: 230, b: 230, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
    }
    
    // Draw diagonal lines pattern
    for i in stride(from: 0, through: 800, by: 40) {
        let i32 = Int32(i)
        _ = SDLWrapper.renderDrawLine(renderer, x1: 0, y1: i32, x2: i32, y2: 0)
        _ = SDLWrapper.renderDrawLine(renderer, x1: Int32(800 - i), y1: 0, x2: 800, y2: i32)
        _ = SDLWrapper.renderDrawLine(renderer, x1: 0, y1: Int32(600 - i), x2: i32, y2: 600)
        _ = SDLWrapper.renderDrawLine(renderer, x1: Int32(800 - i), y1: 600, x2: 800, y2: Int32(600 - i))
    }

    // Draw a decorative frame around the cat
    // Outer frame
    if SDLWrapper.setRenderDrawColor(renderer, r: 100, g: 100, b: 100, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
    }
    _ = SDLWrapper.renderDrawRect(renderer, x: 250, y: 150, w: 300, h: 300)

    // Inner frame
    if SDLWrapper.setRenderDrawColor(renderer, r: 150, g: 150, b: 150, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
    }
    _ = SDLWrapper.renderDrawRect(renderer, x: 260, y: 160, w: 280, h: 280)

    // Draw cat face (gray circle)
    drawFilledCircle(renderer: renderer, centerX: 400, centerY: 300, radius: 100, r: 169, g: 169, b: 169)

    // Draw ears (gray triangles approximated with circles)
    drawFilledCircle(renderer: renderer, centerX: 320, centerY: 220, radius: 40, r: 169, g: 169, b: 169)
    drawFilledCircle(renderer: renderer, centerX: 480, centerY: 220, radius: 40, r: 169, g: 169, b: 169)

    // Draw inner ears (pink circles)
    drawFilledCircle(renderer: renderer, centerX: 320, centerY: 220, radius: 25, r: 255, g: 192, b: 203)
    drawFilledCircle(renderer: renderer, centerX: 480, centerY: 220, radius: 25, r: 255, g: 192, b: 203)

    // Draw eyes (black circles)
    drawFilledCircle(renderer: renderer, centerX: 360, centerY: 280, radius: 15, r: 0, g: 0, b: 0)
    drawFilledCircle(renderer: renderer, centerX: 440, centerY: 280, radius: 15, r: 0, g: 0, b: 0)

    // Draw nose (pink circle)
    drawFilledCircle(renderer: renderer, centerX: 400, centerY: 320, radius: 10, r: 255, g: 192, b: 203)

    // Draw mouth (using lines instead of circles for better performance)
    if SDLWrapper.setRenderDrawColor(renderer, r: 0, g: 0, b: 0, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
    }
    
    for i in -15...15 {
        let x1 = Int32(400 + i * 2)
        let y1 = 350 + Int32((Double(i) * Double(i)) / 20.0)
        let x2 = x1 + 2
        let y2 = 350 + Int32((Double(i + 1) * Double(i + 1)) / 20.0)
        _ = SDLWrapper.renderDrawLine(renderer, x1: x1, y1: y1, x2: x2, y2: y2)
    }

    // Draw whiskers using lines
    // Left whiskers
    for i in 0...2 {
        let y = Int32(315 + i * 5)
        _ = SDLWrapper.renderDrawLine(renderer, x1: 340, y1: y, x2: 280, y2: y + Int32(i * 3) - 3)
    }
    
    // Right whiskers
    for i in 0...2 {
        let y = Int32(315 + i * 5)
        _ = SDLWrapper.renderDrawLine(renderer, x1: 460, y1: y, x2: 520, y2: y + Int32(i * 3) - 3)
    }

    // Draw mouse cursor position indicator
    if SDLWrapper.setRenderDrawColor(renderer, r: 255, g: 0, b: 0, a: 255) < 0 {
        print("Warning: Failed to set render color: \(SDLWrapper.getError())")
    }
    _ = SDLWrapper.renderDrawLine(renderer, x1: mouseX - 10, y1: mouseY, x2: mouseX + 10, y2: mouseY)
    _ = SDLWrapper.renderDrawLine(renderer, x1: mouseX, y1: mouseY - 10, x2: mouseX, y2: mouseY + 10)

    // Update screen
    SDLWrapper.renderPresent(renderer)
}

// Event loop - keep window open until user closes it
var quit = false

// Set up signal handling for clean exit
let sigintSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
sigintSource.setEventHandler {
    print("\nReceived interrupt signal, cleaning up...")
    SDLWrapper.destroyWindow(window)
    SDLWrapper.quit()
    exit(0)
}
sigintSource.resume()

var event = SDLEvent()
var frameCount: UInt64 = 0
while !quit {
    // Get current mouse state
    let mouseState = SDLWrapper.getMouseState()
    
    // Update window title with mouse coordinates
    let title = "Interactive Cat Drawing - Mouse: (\(mouseState.x), \(mouseState.y))"
    SDLWrapper.setWindowTitle(window, title)
    
    // Draw the scene
    drawScene(mouseX: mouseState.x, mouseY: mouseState.y)
    
    // Check for quit events
    while SDLWrapper.pollEvent(&event) > 0 {
        if event.type == SDLWrapper.SDL_QUIT {
            quit = true
        }
    }
    
    // Add small delay to prevent high CPU usage
    SDLWrapper.delay(16) // Approximately 60 FPS
    frameCount += 1
}

// Cleanup
print("Cleaning up...")
SDLWrapper.destroyWindow(window)
SDLWrapper.quit()
print("Goodbye!") 