local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GuiService = game:GetService("GuiService")
local AvatarIdentification = require(ParentParentParent.AvatarIdentification).AvatarIdentification
local Dash = require(ParentParentParent.Dash)
local getAvatarAssets = require(ParentParent.Utils.getAvatarAssets)
local v7 = game:DefineFastInt("CaptureMetadataGetAvatarsTimeoutMs", 150)
local v8 = game:DefineFastInt("CaptureMetadataMaxAvatars", 5)
local v9 = game:DefineFastInt("CaptureMetadataMinAvatarBoundingBoxPixels", 200)
local v10 = game:DefineFastInt("CaptureMetadataMinHitRatePercentage", 50)

local function getViewportSize() -- line: 17
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	return CurrentCamera.ViewportSize
end

local round = math.round

local function vec2ToTable(p1) -- line: 28
	-- upvalues: round (copy)
	return {
		x = round(p1.X),
		y = round(p1.Y)
	}
end

return function() -- line: 32
	-- upvalues: v7 (copy), AvatarIdentification (copy), Dash (copy), GuiService (copy), v8 (copy), v10 (copy), v9 (copy), getAvatarAssets (copy), round (copy)
	local CurrentCamera = workspace.CurrentCamera
	local v17 = if CurrentCamera then CurrentCamera.ViewportSize else nil

	if not v17 then
		return {}
	end

	local v18 = v7 / 1000
	local v19 = AvatarIdentification.getVisibleAvatars(true, v18)
	local v20 = Dash.values(v19)
	local RawScreenScale = GuiService:GetRawScreenScale()

	for _, v23 in v20 do
		v23.boundingBox.min = v23.boundingBox.min * v17 * RawScreenScale
		v23.boundingBox.max = v23.boundingBox.max * v17 * RawScreenScale
	end

	table.sort(v20, function(p2, p3) -- line: 50
		return (p2.boundingBox.max - p2.boundingBox.min).Magnitude > (p3.boundingBox.max - p3.boundingBox.min).Magnitude
	end)

	local n1 = 0
	local t1 = {}

	for _, v27 in v20 do
		if n1 >= v8 then
			return t1
		end

		n1 += 1

		if not (v27.hitRate < v10 / 100) then
			if (v27.boundingBox.max - v27.boundingBox.min).Magnitude < v9 then
				return t1
			end

			local player = v27.player
			local v29 = getAvatarAssets(player.Character)
			local UserId = player.UserId
			local t2 = {
				avatarItems = v29
			}
			local t3 = {}
			local min = v27.boundingBox.min

			t3.min = {
				x = round(min.X),
				y = round(min.Y)
			}

			local max = v27.boundingBox.max

			t3.max = {
				x = round(max.X),
				y = round(max.Y)
			}
			t2.boundingBox = t3
			t1[UserId] = t2
		end
	end

	return t1
end
