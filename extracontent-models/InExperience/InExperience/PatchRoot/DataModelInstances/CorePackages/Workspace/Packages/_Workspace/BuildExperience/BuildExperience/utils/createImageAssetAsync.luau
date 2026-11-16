local parent = script:FindFirstAncestor("BuildExperience").Parent

local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)

local AssetUserAuth = require(parent.DataHydration.AssetUserAuth)
local getAssetUserAuthStore = AssetUserAuth.getAssetUserAuthStore

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Debug = CreatorAgentChat.debug

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function cropToSquareAsync(p: string)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return AssetService:CreateEditableImageAsync(Content.fromUri(p))
		end)

		if not (success and result) then
			callback2(`Failed to create EditableImage: {tostring(result)}`)
			return
		end

		local size = result.Size
		local x = size.X
		local y = size.Y
		local v = math.min(x, y)
		local v2 = math.floor((x - v) / 2)
		local v3 = math.floor((y - v) / 2)

		local pixelsBuffer = result:ReadPixelsBuffer(Vector2.new(v2, v3), Vector2.new(v, v))
		result:Destroy()

		local v4 = v * v * 4
		local v5 = v4 + 54
		local buf = buffer.create(v5)

		buffer.writeu8(buf, 0, 66)
		buffer.writeu8(buf, 1, 77)
		buffer.writeu32(buf, 2, v5)
		buffer.writeu32(buf, 6, 0)
		buffer.writeu32(buf, 10, 54)

		buffer.writeu32(buf, 14, 40)
		buffer.writei32(buf, 18, v)
		buffer.writei32(buf, 22, -v)
		buffer.writeu16(buf, 26, 1)
		buffer.writeu16(buf, 28, 32)
		buffer.writeu32(buf, 30, 0)
		buffer.writeu32(buf, 34, v4)
		buffer.writeu32(buf, 38, 2835)
		buffer.writeu32(buf, 42, 2835)
		buffer.writeu32(buf, 46, 0)
		buffer.writeu32(buf, 50, 0)

		for i = 0, v * v - 1 do
			local v6 = i * 4
			local v7 = i * 4 + 54
			local v8 = buffer.readu8(pixelsBuffer, v6)
			local v9 = buffer.readu8(pixelsBuffer, v6 + 1)
			local v10 = buffer.readu8(pixelsBuffer, v6 + 2)
			local v11 = buffer.readu8(pixelsBuffer, v6 + 3)
			buffer.writeu8(buf, v7, v10)
			buffer.writeu8(buf, v7 + 1, v9)
			buffer.writeu8(buf, v7 + 2, v8)
			buffer.writeu8(buf, v7 + 3, v11)
		end

		callback(buffer.tostring(buf))
	end)
end

local function createImageAssetAsync(url: string, value: string?, cropSquare: boolean?, p)
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return Promise.reject("No local player")
	end

	local function getImageContent()
		if cropSquare then
			return cropToSquareAsync(url)
		end

		return asPromise((fetch({
			method = "GET",
			url = url,
			analyticsKey = "build-experience.download-thumbnail",
			responseEncoding = "protobuf",
			decode = function(buf: buffer)
				return buf
			end
		}))):andThen(function(buf: buffer)
			return buffer.tostring(buf)
		end)
	end

	Debug.log("info", "create_image_asset starting", { cropSquare = cropSquare })

	return getImageContent():andThen(function(p2: string)
		local assetUserAuthStore = getAssetUserAuthStore()

		local v = {
			displayName = value or "Game Thumbnail"
		}

		if p and p.creatorType == "Group" then
			v.groupId = tostring(p.creatorTargetId)
		else
			v.userId = tostring(localPlayer.UserId)
		end

		return assetUserAuthStore.createImageAsset(p2, cropSquare and "image/bmp" or "image/png", v)
	end):andThen(function(p2)
		return getAssetUserAuthStore().pollUntilDone(p2)
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
