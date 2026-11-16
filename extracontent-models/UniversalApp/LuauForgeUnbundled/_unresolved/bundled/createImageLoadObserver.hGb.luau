local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/hGa")
local getScreenPositionFromGuiObjectInput = require("@game/CorePackages/Workspace/Packages/_Workspace/AdGuiInteractivity/AdGuiInteractivity/getScreenPositionFromGuiObjectInput")
local module3 = require("@luauforge/bundled/hGd")
local module4 = require("@luauforge/bundled/hGe")
local module5 = require("@luauforge/bundled/hGf")
local module6 = require("@luauforge/bundled/hGg")

local OBSERVED_IMAGE_TAG = module.OBSERVED_IMAGE_TAG

game:DefineFastInt("ImageLoadObserverPollIntervalMs", 100)

local function resolveImages(guiObject)
	local guiObjects = {}

	if guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
		table.insert(guiObjects, guiObject)
	end

	for i, guiObject2 in guiObject:GetDescendants() do
		if guiObject2:IsA("ImageLabel") or guiObject2:IsA("ImageButton") then
			table.insert(guiObjects, guiObject2)
		end
	end

	return guiObjects
end

local function createImageLoadObserver(ancestor, data)
	local v5 = os.clock() + (data.timeoutSeconds or 30)
	local v6 = game:GetFastInt("ImageLoadObserverPollIntervalMs") / 1000

	local flag = false

	local v7 = if module6.isEnabled() then module6.new() else nil
	local heartbeatConnection = nil

	local function teardown()
		if heartbeatConnection then
			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end
	end

	local function poll()
		if flag then
			return
		end

		if v5 <= os.clock() then
			flag = true

			if heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end

			if v7 then
				v7:destroy()
			end

			if data.onTimeout then
				data.onTimeout()
			end
		else
			local v8, v9 = getScreenPositionFromGuiObjectInput(ancestor)

			for k, v10 in CollectionService:GetTagged(OBSERVED_IMAGE_TAG) do
				if not v10:IsDescendantOf(ancestor) then
					continue
				end

				for k2, v11 in resolveImages(v10) do
					if module3(v11.Image) and module4(v11) and module5(v11, v8, v9) then
						flag = true

						if v7 then
							v7:flashAndDestroy(v11)
						end

						if heartbeatConnection then
							heartbeatConnection:Disconnect()
							heartbeatConnection = nil
						end

						data.onFirstReport()
						return
					end
				end
			end
		end
	end

	local total = 1e999
	heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
		total += dt

		if total < v6 then
			return
		end

		total = 0
		poll()
	end)

	return {
		destroy = function()
			if not flag then
				flag = true

				if heartbeatConnection then
					heartbeatConnection:Disconnect()
					heartbeatConnection = nil
				end
			end

			if v7 then
				v7:destroy()
			end
		end
	}
end

return createImageLoadObserver
