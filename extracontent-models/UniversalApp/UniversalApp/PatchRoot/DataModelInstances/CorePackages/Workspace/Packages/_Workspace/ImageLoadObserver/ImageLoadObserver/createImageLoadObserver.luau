local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Constants = require(script.Parent.Constants)
local getViewportBounds = require(script.Parent.getViewportBounds)
local isContentImageUri = require(script.Parent.isContentImageUri)
local isImageLoaded = require(script.Parent.isImageLoaded)
local isInstanceVisible = require(script.Parent.isInstanceVisible)
local ImageLoadObserverVisualizer = require(script.Parent.ImageLoadObserverVisualizer)
local OBSERVED_IMAGE_TAG = Constants.OBSERVED_IMAGE_TAG

game:DefineFastInt("ImageLoadObserverPollIntervalMs", 100)

local function resolveImages(p1) -- line: 43
	local t1 = {}

	if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
		table.insert(t1, p1)
	end

	for _, descendant in p1:GetDescendants() do
		if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
			table.insert(t1, descendant)
		end
	end

	return t1
end
local function createImageLoadObserver(p2, t2: {[any]: any}) -- line: 56
	-- upvalues: ImageLoadObserverVisualizer (copy), getViewportBounds (copy), CollectionService (copy), OBSERVED_IMAGE_TAG (copy), resolveImages (copy), isContentImageUri (copy), isImageLoaded (copy), isInstanceVisible (copy), RunService (copy)
	local v18 = os.clock() + (t2.timeoutSeconds or 30)
	local v19 = game:GetFastInt("ImageLoadObserverPollIntervalMs") / 1000
	local u20 = false
	local v21 = if not ImageLoadObserverVisualizer.isEnabled() then nil else ImageLoadObserverVisualizer.new()
	local u22 = nil

	local function teardown() -- line: 65
		-- upvalues: u22 (ref)
		if u22 then
			u22:Disconnect()
			u22 = nil
		end
	end
	local function poll() -- line: 75
		-- upvalues: u20 (ref), v18 (copy), u22 (ref), v21 (copy), t2 (copy), getViewportBounds (copy), p2 (copy), CollectionService (copy), OBSERVED_IMAGE_TAG (copy), resolveImages (copy), isContentImageUri (copy), isImageLoaded (copy), isInstanceVisible (copy)
		if u20 then
			return
		end

		if os.clock() >= v18 then
			u20 = true

			if u22 then
				u22:Disconnect()
				u22 = nil
			end

			if v21 then
				v21:destroy()
			end

			if t2.onTimeout then
				t2.onTimeout()
			end

			return
		end

		local v26, v27 = getViewportBounds(p2)

		for _, v29 in CollectionService:GetTagged(OBSERVED_IMAGE_TAG) do
			if v29:IsDescendantOf(p2) then
				for _, v31 in resolveImages(v29) do
					if isContentImageUri(v31.Image) and isImageLoaded(v31) and isInstanceVisible(v31, v26, v27) then
						u20 = true

						if v21 then
							v21:flashAndDestroy(v31)
						end

						if u22 then
							u22:Disconnect()
							u22 = nil
						end

						t2.onFirstReport()

						return
					end
				end
			end
		end
	end

	local n1 = 1e999

	u22 = RunService.Heartbeat:Connect(function(dt: number) -- line: 118
		-- upvalues: n1 (ref), v19 (copy), poll (copy)
		n1 += dt

		if n1 < v19 then
			return
		end

		n1 = 0
		poll()
	end)

	return {
		destroy = function() -- line: 127
			-- upvalues: u20 (ref), u22 (ref), v21 (copy)
			if not u20 then
				u20 = true

				if u22 then
					u22:Disconnect()
					u22 = nil
				end
			end

			if v21 then
				v21:destroy()
			end
		end
	}
end

return createImageLoadObserver
