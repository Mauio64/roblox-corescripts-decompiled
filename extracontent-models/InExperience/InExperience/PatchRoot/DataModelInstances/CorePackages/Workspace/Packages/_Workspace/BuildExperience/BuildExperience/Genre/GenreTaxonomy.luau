local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local ExperienceGenre = require(BuildExperienceParent.DataHydration.ExperienceGenre)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

return {
	version = ExperienceGenre.ExperienceGenreStoreTypes.DEFAULT_TAXONOMY_VERSION,
	genres = {
		{
			id = "action",
			displayName = LocalizationStrings.GENRE_ACTION_NAME,
			description = LocalizationStrings.GENRE_ACTION_DESCRIPTION,
			subgenres = {
				{
					id = "battle_royale",
					displayName = LocalizationStrings.GENRE_BATTLE_ROYALE_NAME,
					description = LocalizationStrings.GENRE_BATTLE_ROYALE_DESCRIPTION
				},
				{
					id = "fighting",
					displayName = LocalizationStrings.GENRE_FIGHTING_NAME,
					description = LocalizationStrings.GENRE_FIGHTING_DESCRIPTION
				},
				{
					id = "shooter",
					displayName = LocalizationStrings.GENRE_ACTION_SHOOTER_NAME,
					description = LocalizationStrings.GENRE_ACTION_SHOOTER_DESCRIPTION
				}
			}
		},
		{
			id = "adventure",
			displayName = LocalizationStrings.GENRE_ADVENTURE_NAME,
			description = LocalizationStrings.GENRE_ADVENTURE_DESCRIPTION,
			subgenres = {
				{
					id = "exploration",
					displayName = LocalizationStrings.GENRE_EXPLORATION_NAME,
					description = LocalizationStrings.GENRE_EXPLORATION_DESCRIPTION
				},
				{
					id = "story",
					displayName = LocalizationStrings.GENRE_STORY_NAME,
					description = LocalizationStrings.GENRE_STORY_DESCRIPTION
				},
				{
					id = "scavenger_hunt",
					displayName = LocalizationStrings.GENRE_SCAVENGER_HUNT_NAME,
					description = LocalizationStrings.GENRE_SCAVENGER_HUNT_DESCRIPTION
				}
			}
		},
		{
			id = "comedy",
			displayName = LocalizationStrings.GENRE_COMEDY_NAME,
			description = LocalizationStrings.GENRE_COMEDY_DESCRIPTION,
			subgenres = {
				{
					id = "memes",
					displayName = LocalizationStrings.GENRE_MEMES_NAME,
					description = LocalizationStrings.GENRE_MEMES_DESCRIPTION
				},
				{
					id = "funny_animations",
					displayName = LocalizationStrings.GENRE_FUNNY_ANIMATIONS_NAME,
					description = LocalizationStrings.GENRE_FUNNY_ANIMATIONS_DESCRIPTION
				}
			}
		},
		{
			id = "horror",
			displayName = LocalizationStrings.GENRE_HORROR_NAME,
			description = LocalizationStrings.GENRE_HORROR_DESCRIPTION,
			subgenres = {
				{
					id = "survival_horror",
					displayName = LocalizationStrings.GENRE_SURVIVAL_HORROR_NAME,
					description = LocalizationStrings.GENRE_SURVIVAL_HORROR_DESCRIPTION
				},
				{
					id = "jumpscare",
					displayName = LocalizationStrings.GENRE_JUMPSCARE_NAME,
					description = LocalizationStrings.GENRE_JUMPSCARE_DESCRIPTION
				}
			}
		},
		{
			id = "life",
			displayName = LocalizationStrings.GENRE_LIFE_NAME,
			description = LocalizationStrings.GENRE_LIFE_DESCRIPTION,
			subgenres = {
				{
					id = "roleplay",
					displayName = LocalizationStrings.GENRE_ROLEPLAY_NAME,
					description = LocalizationStrings.GENRE_ROLEPLAY_DESCRIPTION
				},
				{
					id = "avatar_sim",
					displayName = LocalizationStrings.GENRE_AVATAR_SIMULATOR_NAME,
					description = LocalizationStrings.GENRE_AVATAR_SIMULATOR_DESCRIPTION
				},
				{
					id = "social_hangout",
					displayName = LocalizationStrings.GENRE_SOCIAL_HANGOUT_NAME,
					description = LocalizationStrings.GENRE_SOCIAL_HANGOUT_DESCRIPTION
				}
			}
		},
		{
			id = "party",
			displayName = LocalizationStrings.GENRE_PARTY_NAME,
			description = LocalizationStrings.GENRE_PARTY_DESCRIPTION,
			subgenres = {
				{
					id = "minigames",
					displayName = LocalizationStrings.GENRE_MINIGAMES_NAME,
					description = LocalizationStrings.GENRE_MINIGAMES_DESCRIPTION
				},
				{
					id = "obby",
					displayName = LocalizationStrings.GENRE_OBBY_NAME,
					description = LocalizationStrings.GENRE_OBBY_DESCRIPTION
				}
			}
		},
		{
			id = "puzzle",
			displayName = LocalizationStrings.GENRE_PUZZLE_NAME,
			description = LocalizationStrings.GENRE_PUZZLE_DESCRIPTION,
			subgenres = {
				{
					id = "escape",
					displayName = LocalizationStrings.GENRE_ESCAPE_ROOM_NAME,
					description = LocalizationStrings.GENRE_ESCAPE_ROOM_DESCRIPTION
				},
				{
					id = "trivia",
					displayName = LocalizationStrings.GENRE_TRIVIA_NAME,
					description = LocalizationStrings.GENRE_TRIVIA_DESCRIPTION
				}
			}
		},
		{
			id = "rpg",
			displayName = LocalizationStrings.GENRE_RPG_NAME,
			description = LocalizationStrings.GENRE_RPG_DESCRIPTION,
			subgenres = {
				{
					id = "mmo",
					displayName = LocalizationStrings.GENRE_MMORPG_NAME,
					description = LocalizationStrings.GENRE_MMORPG_DESCRIPTION
				},
				{
					id = "action_rpg",
					displayName = LocalizationStrings.GENRE_ACTION_RPG_NAME,
					description = LocalizationStrings.GENRE_ACTION_RPG_DESCRIPTION
				},
				{
					id = "turn_based_rpg",
					displayName = LocalizationStrings.GENRE_TURN_BASED_RPG_NAME,
					description = LocalizationStrings.GENRE_TURN_BASED_RPG_DESCRIPTION
				}
			}
		},
		{
			id = "shooter",
			displayName = LocalizationStrings.GENRE_SHOOTER_NAME,
			description = LocalizationStrings.GENRE_SHOOTER_DESCRIPTION,
			subgenres = {
				{
					id = "fps",
					displayName = LocalizationStrings.GENRE_FPS_NAME,
					description = LocalizationStrings.GENRE_FPS_DESCRIPTION
				},
				{
					id = "tps",
					displayName = LocalizationStrings.GENRE_TPS_NAME,
					description = LocalizationStrings.GENRE_TPS_DESCRIPTION
				}
			}
		},
		{
			id = "simulator",
			displayName = LocalizationStrings.GENRE_SIMULATOR_NAME,
			description = LocalizationStrings.GENRE_SIMULATOR_DESCRIPTION,
			subgenres = {
				{
					id = "incremental",
					displayName = LocalizationStrings.GENRE_INCREMENTAL_NAME,
					description = LocalizationStrings.GENRE_INCREMENTAL_DESCRIPTION
				},
				{
					id = "tycoon",
					displayName = LocalizationStrings.GENRE_TYCOON_NAME,
					description = LocalizationStrings.GENRE_TYCOON_DESCRIPTION
				}
			}
		},
		{
			id = "social",
			displayName = LocalizationStrings.GENRE_SOCIAL_NAME,
			description = LocalizationStrings.GENRE_SOCIAL_DESCRIPTION,
			subgenres = {
				{
					id = "dance_club",
					displayName = LocalizationStrings.GENRE_DANCE_CLUB_NAME,
					description = LocalizationStrings.GENRE_DANCE_CLUB_DESCRIPTION
				},
				{
					id = "showcase",
					displayName = LocalizationStrings.GENRE_SHOWCASE_NAME,
					description = LocalizationStrings.GENRE_SHOWCASE_DESCRIPTION
				}
			}
		},
		{
			id = "sports",
			displayName = LocalizationStrings.GENRE_SPORTS_NAME,
			description = LocalizationStrings.GENRE_SPORTS_DESCRIPTION,
			subgenres = {
				{
					id = "racing",
					displayName = LocalizationStrings.GENRE_RACING_NAME,
					description = LocalizationStrings.GENRE_RACING_DESCRIPTION
				},
				{
					id = "team_sports",
					displayName = LocalizationStrings.GENRE_TEAM_SPORTS_NAME,
					description = LocalizationStrings.GENRE_TEAM_SPORTS_DESCRIPTION
				}
			}
		},
		{
			id = "strategy",
			displayName = LocalizationStrings.GENRE_STRATEGY_NAME,
			description = LocalizationStrings.GENRE_STRATEGY_DESCRIPTION,
			subgenres = {
				{
					id = "rts",
					displayName = LocalizationStrings.GENRE_RTS_NAME,
					description = LocalizationStrings.GENRE_RTS_DESCRIPTION
				},
				{
					id = "tower_defense",
					displayName = LocalizationStrings.GENRE_TOWER_DEFENSE_NAME,
					description = LocalizationStrings.GENRE_TOWER_DEFENSE_DESCRIPTION
				}
			}
		},
		{
			id = "survival",
			displayName = LocalizationStrings.GENRE_SURVIVAL_NAME,
			description = LocalizationStrings.GENRE_SURVIVAL_DESCRIPTION,
			subgenres = {
				{
					id = "open_world_survival",
					displayName = LocalizationStrings.GENRE_OPEN_WORLD_SURVIVAL_NAME,
					description = LocalizationStrings.GENRE_OPEN_WORLD_SURVIVAL_DESCRIPTION
				},
				{
					id = "zombie_survival",
					displayName = LocalizationStrings.GENRE_ZOMBIE_SURVIVAL_NAME,
					description = LocalizationStrings.GENRE_ZOMBIE_SURVIVAL_DESCRIPTION
				}
			}
		},
		{
			id = "utility",
			displayName = LocalizationStrings.GENRE_UTILITY_NAME,
			description = LocalizationStrings.GENRE_UTILITY_DESCRIPTION,
			subgenres = {
				{
					id = "education",
					displayName = LocalizationStrings.GENRE_EDUCATION_NAME,
					description = LocalizationStrings.GENRE_EDUCATION_DESCRIPTION
				},
				{
					id = "showroom",
					displayName = LocalizationStrings.GENRE_SHOWROOM_NAME,
					description = LocalizationStrings.GENRE_SHOWROOM_DESCRIPTION
				}
			}
		},
		{
			id = "vehicle",
			displayName = LocalizationStrings.GENRE_VEHICLE_NAME,
			description = LocalizationStrings.GENRE_VEHICLE_DESCRIPTION,
			subgenres = {
				{
					id = "driving",
					displayName = LocalizationStrings.GENRE_DRIVING_NAME,
					description = LocalizationStrings.GENRE_DRIVING_DESCRIPTION
				},
				{
					id = "flight",
					displayName = LocalizationStrings.GENRE_FLIGHT_NAME,
					description = LocalizationStrings.GENRE_FLIGHT_DESCRIPTION
				}
			}
		},
		{
			id = "na",
			displayName = LocalizationStrings.GENRE_NONE_NAME,
			description = LocalizationStrings.GENRE_NONE_DESCRIPTION,
			subgenres = {}
		}
	}
}
