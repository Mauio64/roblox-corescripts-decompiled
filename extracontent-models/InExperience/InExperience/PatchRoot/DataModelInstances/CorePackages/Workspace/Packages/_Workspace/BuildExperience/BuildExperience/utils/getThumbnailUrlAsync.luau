local parent = script:FindFirstAncestor("BuildExperience").Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Debug = CreatorAgentChat.debug

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local url = Url.THUMBNAILS_URL .. "v1/batch"

local function getThumbnailUrlAsync(p: number, value: string?)
	local size = value or "420x420"

	Debug.log("info", "thumbnail_url polling", { assetId = p })

	return Promise.new(function(callback, callback2)
		local count = 0
		local function poll(p2: number)
			asPromise((fetch({
				method = "POST",
				url = url,
				body = {
					{ targetId = p, type = "Asset", size = size, format = "Png" }
				},
				analyticsKey = "build-experience.get-thumbnail-url",
				decode = function(p3)
					return p3
				end
			}))):andThen(function(p3)
				local data = p3 and p3.data

				if not data or #data == 0 then
					callback2("No thumbnail data returned")
					return
				end

				local v = data[1]

				if v.state == "Completed" then
					Debug.log("info", "thumbnail_url completed", { assetId = p })
					callback({ status = "completed", imageUrl = v.imageUrl })
				elseif v.state == "InReview" then
					count += 1

					if count >= 5 then
						Debug.log("warn", "thumbnail_url in_review timeout", { assetId = p })
						callback({ status = "in_review", assetId = p })
					else
						task.delay(2, function()
							poll(p2 + 1)
						end)
					end
				elseif v.state ~= "Pending" then
					callback2(`Thumbnail failed: {v.state}`)
				elseif p2 >= 15 then
					Debug.log("warn", "thumbnail_url timed out", { assetId = p })
					callback2("Thumbnail generation timed out")
				else
					task.delay(2, function()
						poll(p2 + 1)
					end)
				end
			end):catch(function(p3)
				callback2(p3)
			end)
		end

		poll(1)
	end)
end

return getThumbnailUrlAsync
