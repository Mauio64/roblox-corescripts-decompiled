local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local Promise = require(parent.Promise)
local ArgCheck = require(parent.ArgCheck)
local Result = require(parent.Result)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch

local GamesMultigetDetails = require(script.Parent.GamesMultigetDetails)
local AddGameDetails = require(GameDetailRodux.GameDetails.AddGameDetails)
local SetGameDetailError = require(GameDetailRodux.GameDetails.SetGameDetailError)
local GameDetailModel = require(GameDetailRodux.GameDetails.GameDetailModel)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local EnumGameDetailErrorTypes = DiscoveryTypes.EnumGameDetailErrorTypes

local Logger = require(GameDetailRodux.Logger)

local function fn(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.gamesapi.games." .. p
end

local ApiFetchGameDetails = {}
ApiFetchGameDetails.KeyMapper = fn

function ApiFetchGameDetails.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fn(p2)) -- inferred equivalent call
end

function ApiFetchGameDetails.Fetch(p, p2)
	ArgCheck.isType(p2, "table", "ApiFetchGameDetails: universeIds")

	return PerformFetch.Batch(p2, fn, function(object, items)
		return GamesMultigetDetails(p, items):andThen(function(p3)
			local v = {}

			local data = p3 and p3.responseBody and p3.responseBody.data

			if data == nil then
				Logger:warning("Response from GamesMultigetDetails is malformed!")
			else
				local v2 = {}

				for _, v3 in ipairs(data) do
					local v4 = GameDetailModel.fromJsonData(v3)
					v2[v4.id] = v4
					v[fn(v4.id)] = Result.new(true, v4) -- inferred equivalent call
				end

				for _, item in pairs(items) do
					if not v2[item] then
						object:dispatch(SetGameDetailError(item, EnumGameDetailErrorTypes.ExperienceUnavailable))
					end
				end

				if next(v2) then
					object:dispatch(AddGameDetails(v2))
				end
			end

			return Promise.resolve(v)
		end, function(_)
			return Promise.resolve({})
		end)
	end)
end

return ApiFetchGameDetails
