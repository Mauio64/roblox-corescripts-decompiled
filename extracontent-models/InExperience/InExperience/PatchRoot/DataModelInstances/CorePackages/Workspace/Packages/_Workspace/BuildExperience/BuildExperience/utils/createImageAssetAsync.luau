local Parent = script:FindFirstAncestor("BuildExperience").Parent
local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")
local HttpClient = require(Parent.HttpClient)
local Promise = require(Parent.Promise)
local getAssetUserAuthStore = require(Parent.DataHydration.AssetUserAuth).getAssetUserAuthStore
local debug = require(Parent.DataHydration.CreatorAgentChat).debug
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function cropToSquareAsync(s1: string) -- line: 20
	-- upvalues: Promise (copy), AssetService (copy)
	return Promise.new(function(resolve, reject) -- line: 21
		-- upvalues: AssetService (copy), s1 (copy)
		local ok, result = pcall(function() -- line: 22
			-- upvalues: AssetService (copy), s1 (copy)
			return AssetService:CreateEditableImageAsync(Content.fromUri(s1))
		end)

		if not ok or not result then
			reject(`Failed to create EditableImage: { tostring(result) }`)

			return
		end

		local resultSize = result.Size
		local resultSizeX = resultSize.X
		local resultSizeY = resultSize.Y
		local v26 = math.min(resultSizeX, resultSizeY)
		local v27 = math.floor((resultSizeX - v26) / 2)
		local v28 = math.floor((resultSizeY - v26) / 2)
		local v29 = result:ReadPixelsBuffer(Vector2.new(v27, v28), Vector2.new(v26, v26))

		result:Destroy()

		local v30 = v26 * v26 * 4
		local v31 = v30 + 54
		local buf = buffer.create(v31)

		buffer.writeu8(buf, 0, 66)
		buffer.writeu8(buf, 1, 77)
		buffer.writeu32(buf, 2, v31)
		buffer.writeu32(buf, 6, 0)
		buffer.writeu32(buf, 10, 54)
		buffer.writeu32(buf, 14, 40)
		buffer.writei32(buf, 18, v26)
		buffer.writei32(buf, 22, -v26)
		buffer.writeu16(buf, 26, 1)
		buffer.writeu16(buf, 28, 32)
		buffer.writeu32(buf, 30, 0)
		buffer.writeu32(buf, 34, v30)
		buffer.writeu32(buf, 38, 2835)
		buffer.writeu32(buf, 42, 2835)
		buffer.writeu32(buf, 46, 0)
		buffer.writeu32(buf, 50, 0)

		for i = 0, v26 * v26 - 1 do
			local v34 = i * 4
			local v35 = i * 4 + 54
			local v36 = buffer.readu8(v29, v34)
			local v37 = buffer.readu8(v29, v34 + 1)
			local v38 = buffer.readu8(v29, v34 + 2)
			local v39 = buffer.readu8(v29, v34 + 3)

			buffer.writeu8(buf, v35, v38)
			buffer.writeu8(buf, v35 + 1, v37)
			buffer.writeu8(buf, v35 + 2, v36)
			buffer.writeu8(buf, v35 + 3, v39)
		end

		resolve(buffer.tostring(buf))
	end)
end
local function createImageAssetAsync(s2: string, s3: string?, b1: boolean?, t1: {[any]: any}?) -- line: 88
	-- upvalues: Players (copy), Promise (copy), cropToSquareAsync (copy), fetch (copy), asPromise (copy), debug (copy), getAssetUserAuthStore (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return Promise.reject("No local player")
	end

	local function getImageContent() -- line: 99
		-- upvalues: b1 (copy), cropToSquareAsync (copy), s2 (copy), fetch (copy), asPromise (copy)
		if b1 then
			return cropToSquareAsync(s2)
		end

		local v40 = fetch({
			method = "GET",
			analyticsKey = "build-experience.download-thumbnail",
			responseEncoding = "protobuf",
			url = s2,
			decode = function(p1: buffer) -- line: 108
				return p1
			end
		})

		return asPromise(v40):andThen(function(p2: buffer) -- line: 112
			return buffer.tostring(p2)
		end)
	end

	debug.log("info", "create_image_asset starting", {
		cropSquare = b1
	})

	return getImageContent():andThen(function(s4: string) -- line: 121
		-- upvalues: b1 (copy), getAssetUserAuthStore (copy), s3 (copy), t1 (copy), LocalPlayer (copy)
		local v42 = not b1 and "image/png" or "image/bmp"
		local v43 = getAssetUserAuthStore()
		local t2 = {
			displayName = s3 or "Game Thumbnail"
		}

		if t1 and t1.creatorType == "Group" then
			t2.groupId = tostring(t1.creatorTargetId)
		else
			t2.userId = tostring(LocalPlayer.UserId)
		end

		return v43.createImageAsset(s4, v42, t2)
	end):andThen(function(p3) -- line: 134
		-- upvalues: getAssetUserAuthStore (copy)
		return getAssetUserAuthStore().pollUntilDone(p3)
	end):andThen(function(p4) -- line: 138
		-- upvalues: Promise (copy), debug (copy)
		if typeof(p4) == "table" and p4.status == "timed_out" then
			return Promise.reject("Operation did not complete in time")
		end

		local v47 = if p4.status ~= "done" then p4 else p4.operation
		local v48 = v47.response or v47

		debug.log("info", "create_image_asset succeeded", {
			assetId = v48.assetId
		})

		return {
			assetId = v48.assetId
		}
	end)
end

return createImageAssetAsync
