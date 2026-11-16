local parent = script.Parent.Parent
local parent2 = parent.Parent

local GuiService = game:GetService("GuiService")

local AvatarIdentification = require(parent2.AvatarIdentification)
local avatarIdentification = AvatarIdentification.AvatarIdentification
local Dash = require(parent2.Dash)

local getAvatarAssets = require(parent.Utils.getAvatarAssets)

local defineFastInt = game:DefineFastInt("CaptureMetadataGetAvatarsTimeoutMs", 150)
local defineFastInt2 = game:DefineFastInt("CaptureMetadataMaxAvatars", 5)

local defineFastInt3 = game:DefineFastInt("CaptureMetadataMinAvatarBoundingBoxPixels", 200)
local defineFastInt4 = game:DefineFastInt("CaptureMetadataMinHitRatePercentage", 50)

local function getViewportSize() -- 1 equivalent call inferred from this helper
	local currentCamera = workspace.CurrentCamera

	if currentCamera then
		return currentCamera.ViewportSize
	end
end

local round = math.round
local function vec2ToTable(p) -- 2 equivalent calls inferred from this helper
	return { x = round(p.X), y = round(p.Y) }
end

return function()
	local viewportSize = getViewportSize() -- inferred equivalent call

	if not viewportSize then
		return {}
	end

	local v = defineFastInt / 1000
	local visibleAvatars = avatarIdentification.getVisibleAvatars(true, v)
	local values = Dash.values(visibleAvatars)

	local rawScreenScale = GuiService:GetRawScreenScale()

	for _, value in values do
		value.boundingBox.min = value.boundingBox.min * viewportSize * rawScreenScale
		value.boundingBox.max = value.boundingBox.max * viewportSize * rawScreenScale
	end

	table.sort(values, function(a, b): boolean
		return (a.boundingBox.max - a.boundingBox.min).Magnitude > (b.boundingBox.max - b.boundingBox.min).Magnitude
	end)
	local count = 0
	local result = {}

	for _, value in values do
		if defineFastInt2 <= count then
			break
		end

		count += 1

		if value.hitRate < defineFastInt4 / 100 then
			continue
		end

		if (value.boundingBox.max - value.boundingBox.min).Magnitude < defineFastInt3 then
			break
		end

		local player = value.player
		local avatarAssets = getAvatarAssets(player.Character)
		local userId = player.UserId
		result[userId] = {
			avatarItems = avatarAssets,
			boundingBox = {
				min = vec2ToTable(value.boundingBox.min), -- inferred equivalent call
				max = vec2ToTable(value.boundingBox.max) -- inferred equivalent call
			}
		}
	end

	return result
end
