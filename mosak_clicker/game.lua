
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Configure image sheets
local mosakSheetOptions =
{
    frames =
    {
		{   -- idle 1
            x = 3,
            y = 6,
            width = 25,
            height = 54
        },
        {   -- idle 2
            x = 40,
            y = 6,
            width = 25,
            height = 54
        },
        {   -- idle 3
            x = 76,
            y = 6,
            width = 25,
            height = 54
        }
    },
}

local mosakSheet = graphics.newImageSheet( "mosakSheet.png", mosakSheetOptions )

-- Configure image sequences
local mosakSequences = {
    -- non-consecutive frames sequence
    {
        name = "idle",
        frames = { 1,2,3,2 },
        time = 2000,
        loopCount = 0,
        loopDirection = "forward"
    }
}

-- Initialize variables


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	-- Load the background
	local background = display.newImageRect( backGroup, "game_bg.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.width = display.actualContentWidth
    background.height = display.actualContentHeight

	local mosak = display.newSprite(mainGroup, mosakSheet, mosakSequences)
	mosak:scale(15,15)
	mosak.x = display.contentCenterX
	mosak.y = 1300

	mosak:setSequence( "idle" )  -- switch to "idle" sequence
    mosak:play()  -- play the new sequence
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		--gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		--Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
