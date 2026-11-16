local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local getAssetUserAuthStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AssetUserAuth").getAssetUserAuthStore

local Debug = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat").debug

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function cropToSquareAsync(p2)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return AssetService:CreateEditableImageAsync(Content.fromUri(p2))
		end)

		if not (success and result) then
			callback2(`Failed to create EditableImage: {tostring(result)}`)
			return
		end

		local size = result.Size
		local x = size.X
		local y = size.Y
		local v5 = math.min(x, y)
		local v6 = math.floor((x - v5) / 2)
		local v7 = math.floor((y - v5) / 2)

		local pixelsBuffer = result:ReadPixelsBuffer(Vector2.new(v6, v7), Vector2.new(v5, v5))
		result:Destroy()

		local v8 = v5 * v5 * 4
		local v9 = v8 + 54
		local buf = buffer.create(v9)

		buffer.writeu8(buf, 0, 66)
		buffer.writeu8(buf, 1, 77)
		buffer.writeu32(buf, 2, v9)
		buffer.writeu32(buf, 6, 0)
		buffer.writeu32(buf, 10, 54)

		buffer.writeu32(buf, 14, 40)
		buffer.writei32(buf, 18, v5)
		buffer.writei32(buf, 22, -v5)
		buffer.writeu16(buf, 26, 1)
		buffer.writeu16(buf, 28, 32)
		buffer.writeu32(buf, 30, 0)
		buffer.writeu32(buf, 34, v8)
		buffer.writeu32(buf, 38, 2835)
		buffer.writeu32(buf, 42, 2835)
		buffer.writeu32(buf, 46, 0)
		buffer.writeu32(buf, 50, 0)

		for i = 0, v5 * v5 - 1 do
			local v10 = i * 4
			local v11 = i * 4 + 54
			local v12 = buffer.readu8(pixelsBuffer, v10)
			local v13 = buffer.readu8(pixelsBuffer, v10 + 1)
			local v14 = buffer.readu8(pixelsBuffer, v10 + 2)
			local v15 = buffer.readu8(pixelsBuffer, v10 + 3)
			buffer.writeu8(buf, v11, v14)
			buffer.writeu8(buf, v11 + 1, v13)
			buffer.writeu8(buf, v11 + 2, v12)
			buffer.writeu8(buf, v11 + 3, v15)
		end

		callback(buffer.tostring(buf))
	end)
end

local function createImageAssetAsync(p2, value, p3, p4)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return Promise.reject("No local player")
	end

	local function getImageContent()
		if p3 then
			return cropToSquareAsync(p2)
		end

		return asPromise((fetch({
			method = "GET",
			url = p2,
			analyticsKey = "build-experience.download-thumbnail",
			responseEncoding = "protobuf",
			decode = function(p5)
				return p5
			end
		}))):andThen(function(buf)
			return buffer.tostring(buf)
		end)
	end

	Debug.log("info", "create_image_asset starting", { cropSquare = p3 })

	return getImageContent():andThen(function(p5)
		local assetUserAuthStore = getAssetUserAuthStore()

		local v6 = {
			displayName = value or "Game Thumbnail"
		}

		if p4 and p4.creatorType == "Group" then
			v6.groupId = tostring(p4.creatorTargetId)
		else
			v6.userId = tostring(localPlayer.UserId)
		end

		return assetUserAuthStore.createImageAsset(p5, p3 and "image/bmp" or "image/png", v6)
	end):andThen(function(p5)
		return getAssetUserAuthStore().pollUntilDone(p5)
	end):andThen(function(data)
		if typeof(data) == "table" and data.status == "timed_out" then
			return Promise.reject("Operation did not complete in time")
		end

		if data.status == "done" then
			data = data.operation
		end

		local response = data.response or data
		Debug.log("info", "create_image_asset succeeded", { assetId = response.assetId })
		return { assetId = response.assetId }
	end)
end

return createImageAssetAsync
