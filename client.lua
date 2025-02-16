local screenW, screenH = guiGetScreenSize()

config = { 
    hung = 'fome',
    thirs = 'sede',
	st = 'stamina', 
}

local browser
local isMicActive = false

function onClientResourceStart()
    browser = createBrowser(screenW, screenH, true, true)
    
    if browser then
        addEventHandler("onClientBrowserCreated", browser, onBrowserCreated)
    else
        outputChatBox("Failed to create browser", 255, 0, 0)
    end
end

function onBrowserCreated()
    loadBrowserURL(browser, "http://mta/local/index.html")
    addEventHandler("onClientRender", root, renderBrowserOnScreen)
    setTimer(updateHUD, 0, 0)  -- Update every frame
end

function renderBrowserOnScreen()
    if browser then
        dxDrawImage(0, 0, screenW, screenH, browser, 0, 0, 0, tocolor(255, 255, 255, 255))
    end
end

addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)

function updateHUD()
    local health = getElementHealth(localPlayer)
    local armor = getPedArmor(localPlayer)
    local hunger = getElementData(localPlayer, config.hung) or 100
    local thirst = getElementData(localPlayer, config.thirs) or 100
    local staminaa = getElementData(localPlayer,config.st) or 100
    
    if browser then
        executeBrowserJavascript(browser, string.format("window.postMessage({type: 'updateHealth', health: %d}, '*')", health))
        executeBrowserJavascript(browser, string.format("window.postMessage({type: 'updateShield', shield: %d}, '*')", armor))
        executeBrowserJavascript(browser, string.format("window.postMessage({type: 'updateFood', food: %d}, '*')", hunger))
        executeBrowserJavascript(browser, string.format("window.postMessage({type: 'updateWater', water: %d}, '*')", thirst))
        executeBrowserJavascript(browser, string.format("window.postMessage({type: 'updateLung', lung: %d}, '*')", staminaa))
        executeBrowserJavascript(browser, string.format("window.postMessage({type: 'updateMic', mic: %d}, '*')", isMicActive and 100 or 0))
    end
end

function onClientPlayerVoiceStart()
    isMicActive = true
    updateHUD()
end
addEventHandler("onClientPlayerVoiceStart", localPlayer, onClientPlayerVoiceStart)

function onClientPlayerVoiceStop()
    isMicActive = false
    updateHUD()
end
addEventHandler("onClientPlayerVoiceStop", localPlayer, onClientPlayerVoiceStop)


local stamina = 100

local stamina_MAX = 100



function staminaCycle()

	local tired = getElementData(localPlayer, "tired")

	if tired then

		stamina = stamina+7

	elseif getPedMoveState(localPlayer) == "stand" then

		stamina = stamina+1

	elseif getPedMoveState(localPlayer) == "walk" then

		stamina = stamina+1

	elseif getPedMoveState(localPlayer) == "powerwalk" then

		stamina = stamina+3

	elseif getPedMoveState(localPlayer) == "jog" then

		stamina = stamina-0.5

	elseif getPedMoveState(localPlayer) == "sprint" then

		stamina = stamina-1

	elseif getPedMoveState(localPlayer) == "jump" then

		stamina = stamina-1

	elseif getPedMoveState(localPlayer) == "crouch" then

		stamina = stamina+5

	elseif getPedMoveState(localPlayer) == "crawl" then

		stamina = stamina-3

	else

		stamina = stamina+1

	end



	if stamina > stamina_MAX then

		stamina = stamina_MAX

	end

	if stamina > 20 then

		toggleControl("jump", true)

	end

	if stamina >= 5 then

		toggleControl("sprint", true)

	end

	if stamina < 0 then

		toggleControl("jump", false)

		toggleControl("sprint", false)

		stamina = 0

		--triggerServerEvent("setTiredAnimation", root, localPlayer)

	end

	setElementData(localPlayer, "stamina", stamina)

	setTimer(staminaCycle, 250, 1)

end

setTimer(staminaCycle, 200, 1)



--[[ 

██████╗ ███████╗███╗   ██╗██╗   ██╗███████╗███████╗
██╔══██╗██╔════╝████╗  ██║██║   ██║╚══███╔╝╚══███╔╝
██║  ██║█████╗  ██╔██╗ ██║██║   ██║  ███╔╝   ███╔╝ 
██║  ██║██╔══╝  ██║╚██╗██║██║   ██║ ███╔╝   ███╔╝  
██████╔╝███████╗██║ ╚████║╚██████╔╝███████╗███████╗
╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝
                                                   
 ____________________________________________________
|                                                   |
| Try to create your own thing. Don't copy others|  |
|___________________________________________________|

All rights reserved by DENUZZ 2025 ©

]]




