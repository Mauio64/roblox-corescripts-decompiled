local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Http").Url

local Debug = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat").debug

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local v5 = url.THUMBNAILS_URL .. "v1/batch"

local function getThumbnailUrlAsync(p2, value)
	local v6 = value or "420x420"

	Debug.log("info", "thumbnail_url polling", { assetId = p2 })

	return Promise.new(function(callback, callback2)
		local count = 0
		local function poll(p3)
			asPromise((fetch({
				method = "POST",
				url = v5,
				body = {
					{ targetId = p2, type = "Asset", size = v6, format = "Png" }
				},
				analyticsKey = "build-experience.get-thumbnail-url",
				decode = function(p4)
					return p4
				end
			}))):andThen(function(p4)
				local data = p4 and p4.data

				if not data or #data == 0 then
					callback2("No thumbnail data returned")
					return
				end

				local v7 = data[1]

				if v7.state == "Completed" then
					Debug.log("info", "thumbnail_url completed", { assetId = p2 })
					callback({ status = "completed", imageUrl = v7.imageUrl })
				elseif v7.state == "InReview" then
					count += 1

					if count >= 5 then
						Debug.log("warn", "thumbnail_url in_review timeout", {
							assetId = p2
						})
						callback({ status = "in_review", assetId = p2 })
					else
						task.delay(2, function()
							poll(p3 + 1)
						end)
					end
				elseif v7.state ~= "Pending" then
					callback2(`Thumbnail failed: {v7.state}`)
				elseif p3 >= 15 then
					Debug.log("warn", "thumbnail_url timed out", { assetId = p2 })
					callback2("Thumbnail generation timed out")
				else
					task.delay(2, function()
						poll(p3 + 1)
					end)
				end
			end):catch(function(p4)
				callback2(p4)
			end)
		end

		poll(1)
	end)
end

return getThumbnailUrlAsync
