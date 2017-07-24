
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
		{   -- 1. idle 1
            x = 3,
            y = 6,
            width = 25,
            height = 54,
			sourceX = 0,
            sourceY = 0,
            sourceWidth = 25,
            sourceHeight = 54
        },
        {   -- 2. idle 2
            x = 40,
            y = 6,
            width = 25,
            height = 54,
			sourceX = 0,
            sourceY = 0,
            sourceWidth = 25,
            sourceHeight = 54
        },
        {   -- 3. idle 3
            x = 76,
            y = 6,
            width = 25,
            height = 54,
			sourceX = 0,
            sourceY = 0,
            sourceWidth = 25,
            sourceHeight = 54
        },
        {   -- 4. swordAxeAttack 1
            x = 9,
            y = 293,
            width = 33,
            height = 58,
			sourceX = 3,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
        },
        {   -- 5. swordAxeAttack 2
            x = 56,
            y = 293,
            width = 36,
            height = 58,
			sourceX = 0,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
        },
        {   -- 6. swordAxeAttack 3
            x = 103,
            y = 293,
            width = 31,
            height = 58,
			sourceX = 5,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
        },
        {   -- 7. swordAxeAttack 4
            x = 146,
            y = 293,
            width = 55,
            height = 58,
			sourceX = 1,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
        },
        {   -- 8. swordAxeAttack 5
            x = 218,
            y = 293,
            width = 53,
            height = 58,
			sourceX = 1,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
        },
        {   -- 9. swordAxeAttack 6
            x = 279,
            y = 293,
            width = 53,
            height = 58,
			sourceX = 1,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
        },
        {   -- 10. swordAxeAttack 7
            x = 339,
            y = 293,
            width = 36,
            height = 58,
			sourceX = 5,
            sourceY = 0,
            sourceWidth = 56,
            sourceHeight = 58
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
    },
	{
        name = "swordAxeAttack",
        frames = { 4,5,6,7,8,9,10 },
        time = 1000,
        loopCount = 1,
        loopDirection = "forward"
    }
}

-- Initialize variables

local mosak
local isAttacking = true
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

--mosakAttackListener()
function mosakAttackListener( event )

	if ( event.phase == "began" ) then 
		isAttacking = false
	elseif ( event.phase == "ended" ) then 
		isAttacking = true
		mosak.y = mosak.y + 25
		mosak.x = mosak.x - 10
        mosak:setSequence( "idle" )  -- switch to "idle" sequence
        mosak:play()  -- play the new sequence
		mosak:removeEventListener("sprite",mosakAttackListener)
    end

end

--attackFunction()
function attackFunction()
	if isAttacking then

		mosak.y = mosak.y - 25
		mosak.x = mosak.x + 10
		mosak:setSequence( "swordAxeAttack" )  -- switch to "swordAxeAttack" sequence
		mosak:play()  -- play the new sequence

		mosak:addEventListener("sprite",mosakAttackListener)
	end

end

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

	mosak = display.newSprite(mainGroup, mosakSheet, mosakSequences)
	mosak:scale(10,10)
	mosak.x = 250
	mosak.y = 1325

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

Runtime:addEventListener( "touch", attackFunction )
-- -----------------------------------------------------------------------------------

return scene
