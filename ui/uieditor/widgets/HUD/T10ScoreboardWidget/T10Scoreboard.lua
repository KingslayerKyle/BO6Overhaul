require( "ui.uieditor.widgets.HUD.T10ScoreboardWidget.T10ScoreboardListItem" )
require( "ui.uieditor.widgets.HUD.T10ScoreboardInventoryWidget.T10ScoreboardInventory" )

local PostLoadFunc = function ( self, controller )
	self.Team1:subscribeToModel( Engine.CreateModel( Engine.GetModelForController( controller ), "updateScoreboard" ), function ( model )
		self.Team1:updateDataSource( false, true )
	end )

	self.Team1:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( model )
		self.Team1:updateDataSource()
	end )

	self.Team1:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "forceScoreboard" ), function ( model )
		self.Team1:updateDataSource()
	end )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( model )
		self.m_inputDisabled = not Engine.GetModelValue( model )
	end )
end

local PreLoadFunc = function ( self, controller )
	CoD.ScoreboardUtility.SetScoreboardUIModels( controller )
end

CoD.T10Scoreboard = InheritFrom( LUI.UIElement )
CoD.T10Scoreboard.new = function ( menu, controller )
    local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10Scoreboard )
	self.id = "T10Scoreboard"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self:makeFocusable()
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true

	self.Background = LUI.UIImage.new()
	self.Background:setLeftRight( true, true, 0, 0 )
	self.Background:setTopBottom( true, true, 0, 0 )
	self.Background:setImage( RegisterImage( "$white" ) )
	self.Background:setRGB( 0, 0, 0 )
	self.Background:setAlpha( 0.5 )
	self:addElement( self.Background )

	self.T10ScoreboardInventory = CoD.T10ScoreboardInventory.new( menu, controller )
	self.T10ScoreboardInventory:setLeftRight( true, true, 0, 0 )
	self.T10ScoreboardInventory:setTopBottom( true, true, 0, 0 )
	self:addElement( self.T10ScoreboardInventory )

	self.RoundIcon = LUI.UIImage.new()
	self.RoundIcon:setLeftRight( true, false, 40, 106.5 )
	self.RoundIcon:setTopBottom( true, false, 23, 89.5 )
	self.RoundIcon:setImage( RegisterImage( "ximage_96144895a5ca00e" ) )
	self:addElement( self.RoundIcon )

	self.RoundTextShadow = LUI.UIText.new()
	self.RoundTextShadow:setLeftRight( true, true, -283, 0 )
	self.RoundTextShadow:setTopBottom( true, false, 0 + 18, 35 + 18 )
	self.RoundTextShadow:setText( Engine.Localize( "" ) )
	self.RoundTextShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.RoundTextShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.RoundTextShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.RoundTextShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.RoundTextShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.RoundTextShadow:setRGB( 0.2, 0.2, 0.2 )
	self.RoundTextShadow:setScale( 0.5 )
	self.RoundTextShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.RoundTextShadow:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "gameScore.roundsPlayed" ), function ( model )
		local roundsPlayed = Engine.GetModelValue( model )
		
		if roundsPlayed then
			if CoD.UsermapName ~= nil then
				self.RoundTextShadow:setText( string.upper( Engine.Localize( CoD.UsermapName ) ) .. " | STANDARD | ROUND " .. Engine.Localize( roundsPlayed - 1 ) )
			end
		end
	end )
	self:addElement( self.RoundTextShadow )

	self.RoundText = LUI.UIText.new()
	self.RoundText:setLeftRight( true, true, -283, 0 )
	self.RoundText:setTopBottom( true, false, 0 + 18, 35 + 18 )
	self.RoundText:setText( Engine.Localize( "" ) )
	self.RoundText:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.RoundText:setRGB( 0.89, 0.43, 0.09 )
	self.RoundText:setScale( 0.5 )
	self.RoundText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.RoundText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "gameScore.roundsPlayed" ), function ( model )
		local roundsPlayed = Engine.GetModelValue( model )
		
		if roundsPlayed then
			if CoD.UsermapName ~= nil then
				self.RoundText:setText( string.upper( Engine.Localize( CoD.UsermapName ) ) .. " | STANDARD | ROUND " .. Engine.Localize( roundsPlayed - 1 ) )
			end
		end
	end )
	self:addElement( self.RoundText )

	self.TitleShadow = LUI.UIText.new()
	self.TitleShadow:setLeftRight( true, true, -285, 0 )
	self.TitleShadow:setTopBottom( true, false, 0 + 22, 69 + 22 )
	self.TitleShadow:setText( Engine.Localize( "ROUND-BASED ZOMBIES" ) )
	self.TitleShadow:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.TitleShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.TitleShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.TitleShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.TitleShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.TitleShadow:setRGB( 0.2, 0.2, 0.2 )
	self.TitleShadow:setScale( 0.5 )
	self.TitleShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.TitleShadow )

	self.Title = LUI.UIText.new()
	self.Title:setLeftRight( true, true, -285, 0 )
	self.Title:setTopBottom( true, false, 0 + 22, 69 + 22 )
	self.Title:setText( Engine.Localize( "ROUND-BASED ZOMBIES" ) )
	self.Title:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Title:setScale( 0.5 )
	self.Title:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.Title )

	self.TitleDivider = LUI.UIImage.new()
	self.TitleDivider:setLeftRight( true, false, 108, 308 )
	self.TitleDivider:setTopBottom( true, false, 69.5, 73 )
	self.TitleDivider:setImage( RegisterImage( "ximage_63aafe44198a60e" ) )
	self.TitleDivider:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.TitleDivider )

	self.HeaderBG = LUI.UIImage.new()
	self.HeaderBG:setLeftRight( false, false, -516.5, 516.5 )
	self.HeaderBG:setTopBottom( true, false, 393.5, 426.5 )
	self.HeaderBG:setImage( RegisterImage( "ximage_ed5cf8b3fc28052" ) )
	self:addElement( self.HeaderBG )

	self.Team1BG = LUI.UIImage.new()
	self.Team1BG:setLeftRight( true, false, 123.5, 1156.5 )
	self.Team1BG:setTopBottom( true, false, 426.5, 560.5 )
	self.Team1BG:setImage( RegisterImage( "$white" ) )
	self.Team1BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_scene_blur_pass_1" ) )
	self.Team1BG:setShaderVector( 0, 0, 30, 0, 0 )
	self.Team1BG:setRGB( 0.75, 0.75, 0.75 )
	self.Team1BG:setAlpha( 0.75 )
	self:addElement( self.Team1BG )

	self.Player1BG = LUI.UIImage.new()
	self.Player1BG:setLeftRight( true, false, 123.5, 1156.5 )
	self.Player1BG:setTopBottom( true, false, 426.5, 460 )
	self.Player1BG:setImage( RegisterImage( "ximage_d18dfae10338ee0" ) )
	self:addElement( self.Player1BG )

	self.Player2BG = LUI.UIImage.new()
	self.Player2BG:setLeftRight( true, false, 123.5, 1156.5 )
	self.Player2BG:setTopBottom( true, false, 426.5 + 33.5, 460 + 33.5 )
	self.Player2BG:setImage( RegisterImage( "ximage_d18dfae10338ee0" ) )
	self:addElement( self.Player2BG )

	self.Player3BG = LUI.UIImage.new()
	self.Player3BG:setLeftRight( true, false, 123.5, 1156.5 )
	self.Player3BG:setTopBottom( true, false, 426.5 + 33.5 + 33.5, 460 + 33.5 + 33.5 )
	self.Player3BG:setImage( RegisterImage( "ximage_d18dfae10338ee0" ) )
	self:addElement( self.Player3BG )

	self.Player4BG = LUI.UIImage.new()
	self.Player4BG:setLeftRight( true, false, 123.5, 1156.5 )
	self.Player4BG:setTopBottom( true, false, 426.5 + 33.5 + 33.5 + 33.5, 460 + 33.5 + 33.5 + 33.5 )
	self.Player4BG:setImage( RegisterImage( "ximage_d18dfae10338ee0" ) )
	self:addElement( self.Player4BG )

	self.MatchTime = LUI.UIText.new()
	self.MatchTime:setLeftRight( true, true, 0, 207 )
	self.MatchTime:setTopBottom( true, false, 365.5 - 5, 410.5 - 5 )
	self.MatchTime:setText( Engine.Localize( "Match Time:" ) )
	self.MatchTime:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.MatchTime:setRGB( 0.85, 0.61, 0 )
	self.MatchTime:setScale( 0.5 )
	self.MatchTime:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( self.MatchTime )

	self.Time = LUI.UIText.new()
	self.Time:setLeftRight( true, true, 1063, 0 )
	self.Time:setTopBottom( true, false, 365.5 - 5, 410.5 - 5 )
	self.Time:setText( Engine.Localize( "" ) )
	self.Time:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.Time:setRGB( 0.85, 0.61, 0 )
	self.Time:setScale( 0.5 )
	self.Time:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Time:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.time.game_start_time" ), function ( model )
		local time = Engine.GetModelValue( model )

		if time then
			self.Time:setupServerTime( time )
		end
	end )
	self:addElement( self.Time )

	self.SelfMainBG = LUI.UIImage.new()
	self.SelfMainBG:setLeftRight( false, false, -666, 666 )
	self.SelfMainBG:setTopBottom( true, false, 574, 647.5 )
	self.SelfMainBG:setImage( RegisterImage( "ximage_3fa1c5d2f8e035d" ) )
	self:addElement( self.SelfMainBG )

	self.SelfCardBG = LUI.UIImage.new()
	self.SelfCardBG:setLeftRight( true, false, 140, 448 )
	self.SelfCardBG:setTopBottom( true, false, 571.5, 650 )
	self.SelfCardBG:setImage( RegisterImage( "ximage_7d4e175ee11d985" ) )
	self:addElement( self.SelfCardBG )

	self.SelfNameShadow = LUI.UIText.new()
	self.SelfNameShadow:setLeftRight( true, false, 140, 448 )
	self.SelfNameShadow:setTopBottom( true, false, 599.5 - 40, 644 - 40 )
	self.SelfNameShadow:setText( Engine.Localize( Engine.GetGamertagForController( controller ) ) )
	self.SelfNameShadow:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.SelfNameShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.SelfNameShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.SelfNameShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.SelfNameShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.SelfNameShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.SelfNameShadow:setRGB( 0, 0, 0 )
	self.SelfNameShadow:setScale( 0.5 )
	self:addElement( self.SelfNameShadow )

	self.SelfName = LUI.UIText.new()
	self.SelfName:setLeftRight( true, false, 140, 448 )
	self.SelfName:setTopBottom( true, false, 599.5 - 40, 644 - 40 )
	self.SelfName:setText( Engine.Localize( Engine.GetGamertagForController( controller ) ) )
	self.SelfName:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.SelfName:setRGB( 0.85, 0.79, 0.70 )
	self.SelfName:setScale( 0.5 )
	self.SelfName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.SelfName )

	self.SelfCallingCard = LUI.UIImage.new()
	self.SelfCallingCard:setLeftRight( true, false, 198, 390 )
	self.SelfCallingCard:setTopBottom( true, false, 599.5, 646 )
	self.SelfCallingCard:setImage( RegisterImage( "t7_loot_callingcard_wawretro_05" ) )
	self:addElement( self.SelfCallingCard )

	self.SelfEmblem = LUI.UIImage.new()
	self.SelfEmblem:setLeftRight( true, false, 151.5 - 5.75, 198 - 5.75 )
	self.SelfEmblem:setTopBottom( true, false, 599.5, 646 )
	self.SelfEmblem:setImage( RegisterImage( "t7_icon_rank_zm_prestige_61_lrg" ) )
	self:addElement( self.SelfEmblem )

	self.SelfRankIcon = LUI.UIImage.new()
	self.SelfRankIcon:setLeftRight( true, false, 390 + 5.75, 436.5 + 5.75 )
	self.SelfRankIcon:setTopBottom( true, false, 599.5, 646 )
	self.SelfRankIcon:setImage( RegisterImage( "t4_icon_rank_mp_prestige_10" ) )
	self:addElement( self.SelfRankIcon )

	self.SelfScoreIcon = LUI.UIImage.new()
	self.SelfScoreIcon:setLeftRight( true, false, 520.5, 541.5 )
	self.SelfScoreIcon:setTopBottom( true, false, 575, 596 )
	self.SelfScoreIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_essence" ) )
	self:addElement( self.SelfScoreIcon )

	self.SelfScoreTitle = LUI.UIText.new()
	self.SelfScoreTitle:setLeftRight( true, true, 357, -184 )
	self.SelfScoreTitle:setTopBottom( true, false, 569, 604 )
	self.SelfScoreTitle:setText( Engine.Localize( "ESSENCE" ) )
	self.SelfScoreTitle:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.SelfScoreTitle:setRGB( 0.8, 0.8, 0.8 )
	self.SelfScoreTitle:setScale( 0.5 )
	self.SelfScoreTitle:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.SelfScoreTitle )

	self.SelfScoreText = LUI.UIText.new()
	self.SelfScoreText:setLeftRight( true, true, 262, 0 )
	self.SelfScoreText:setTopBottom( true, false, 554, 682 )
	self.SelfScoreText:setText( Engine.Localize( "" ) )
	self.SelfScoreText:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.SelfScoreText:setRGB( 0.85, 0.79, 0.70 )
	self.SelfScoreText:setScale( 0.5 )
	self.SelfScoreText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.SelfScoreText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "PlayerList." .. Engine.GetClientNum( 0 ) .. ".playerScore" ), function ( model )
		local score = Engine.GetModelValue( model )

		if score then
			self.SelfScoreText:setText( Engine.Localize( score ) )
		end
	end )
	self:addElement( self.SelfScoreText )

	self.SelfJunkIcon = LUI.UIImage.new()
	self.SelfJunkIcon:setLeftRight( true, false, 685.5, 706.5 )
	self.SelfJunkIcon:setTopBottom( true, false, 575, 596 )
	self.SelfJunkIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_salvage" ) )
	self:addElement( self.SelfJunkIcon )

	self.SelfJunkTitle = LUI.UIText.new()
	self.SelfJunkTitle:setLeftRight( true, true, 563.5, -142.5 )
	self.SelfJunkTitle:setTopBottom( true, false, 569, 604 )
	self.SelfJunkTitle:setText( Engine.Localize( "SALVAGE" ) )
	self.SelfJunkTitle:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.SelfJunkTitle:setRGB( 0.8, 0.8, 0.8 )
	self.SelfJunkTitle:setScale( 0.5 )
	self.SelfJunkTitle:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.SelfJunkTitle )

	self.SelfJunkText = LUI.UIText.new()
	self.SelfJunkText:setLeftRight( true, true, 491, 0 )
	self.SelfJunkText:setTopBottom( true, false, 554, 682 )
	self.SelfJunkText:setText( Engine.Localize( "" ) )
	self.SelfJunkText:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.SelfJunkText:setRGB( 0.85, 0.79, 0.70 )
	self.SelfJunkText:setScale( 0.5 )
	self.SelfJunkText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.SelfJunkText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_junk" ), function ( model )
		local junk = Engine.GetModelValue( model )

		if junk then
			self.SelfJunkText:setText( Engine.Localize( junk ) )
		end
	end )
	self:addElement( self.SelfJunkText )

	self.ScoreColumn0 = LUI.UIText.new()
	self.ScoreColumn0:setLeftRight( true, true, -244, 0 )
	self.ScoreColumn0:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn0:setText( Engine.Localize( "#" ) )
	self.ScoreColumn0:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn0:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn0:setScale( 0.5 )
	self.ScoreColumn0:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn0 )

	self.ScoreColumn1 = LUI.UIText.new()
	self.ScoreColumn1:setLeftRight( true, true, -166, 0 )
	self.ScoreColumn1:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn1:setText( Engine.Localize( "LEVEL" ) )
	self.ScoreColumn1:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn1:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn1:setScale( 0.5 )
	self.ScoreColumn1:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn1 )

	self.ScoreColumn2 = LUI.UIText.new()
	self.ScoreColumn2:setLeftRight( true, true, 3.5, 0 )
	self.ScoreColumn2:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn2:setText( Engine.Localize( "NAME" ) )
	self.ScoreColumn2:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn2:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn2:setScale( 0.5 )
	self.ScoreColumn2:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn2 )

	self.ScoreColumn3 = LUI.UIText.new()
	self.ScoreColumn3:setLeftRight( true, true, 304.5, 0 )
	self.ScoreColumn3:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn3:setText( Engine.Localize( "CURRENT ESSENCE" ) )
	self.ScoreColumn3:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn3:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn3:setScale( 0.5 )
	self.ScoreColumn3:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn3 )

	self.ScoreColumn4 = LUI.UIText.new()
	self.ScoreColumn4:setLeftRight( true, true, 475.5, 0 )
	self.ScoreColumn4:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn4:setText( Engine.Localize( "ELIMINATIONS" ) )
	self.ScoreColumn4:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn4:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn4:setScale( 0.5 )
	self.ScoreColumn4:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn4 )

	self.ScoreColumn5 = LUI.UIText.new()
	self.ScoreColumn5:setLeftRight( true, true, 640.5, 0 )
	self.ScoreColumn5:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn5:setText( Engine.Localize( "CRITICAL KILLS" ) )
	self.ScoreColumn5:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn5:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn5:setScale( 0.5 )
	self.ScoreColumn5:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn5 )

	self.ScoreColumn6 = LUI.UIText.new()
	self.ScoreColumn6:setLeftRight( true, true, 818.5, 0 )
	self.ScoreColumn6:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn6:setText( Engine.Localize( "REVIVES" ) )
	self.ScoreColumn6:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn6:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn6:setScale( 0.5 )
	self.ScoreColumn6:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn6 )

	self.ScoreColumn7 = LUI.UIText.new()
	self.ScoreColumn7:setLeftRight( true, true, 993.5, 0 )
	self.ScoreColumn7:setTopBottom( true, false, 393, 425.5 )
	self.ScoreColumn7:setText( Engine.Localize( "DOWNS" ) )
	self.ScoreColumn7:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.ScoreColumn7:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn7:setScale( 0.5 )
	self.ScoreColumn7:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreColumn7 )

	self.Team1 = LUI.UIList.new( menu, controller, 0, 0, nil, false, false, 0, 0, false, false )
	self.Team1:makeFocusable()
	self.Team1:setLeftRight( true, true, 123.5, 0 )
	self.Team1:setTopBottom( true, true, 426.5, 0 )
	self.Team1:setDataSource( "ScoreboardTeam1List" )
	self.Team1:setWidgetType( CoD.T10ScoreboardListItem )
	self.Team1:setVerticalCount( 9 )
	self:addElement( self.Team1 )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 38 )

				self.Background:completeAnimation() 
				self.Background:setAlpha( 0 ) 
				self.clipFinished( self.Background, {} )
				
				self.T10ScoreboardInventory:completeAnimation() 
				self.T10ScoreboardInventory:setAlpha( 0 ) 
				self.clipFinished( self.T10ScoreboardInventory, {} )
				
				self.RoundIcon:completeAnimation() 
				self.RoundIcon:setAlpha( 0 ) 
				self.clipFinished( self.RoundIcon, {} )
				
				self.RoundTextShadow:completeAnimation() 
				self.RoundTextShadow:setAlpha( 0 ) 
				self.clipFinished( self.RoundTextShadow, {} )
				
				self.RoundText:completeAnimation() 
				self.RoundText:setAlpha( 0 ) 
				self.clipFinished( self.RoundText, {} )
				
				self.TitleShadow:completeAnimation() 
				self.TitleShadow:setAlpha( 0 ) 
				self.clipFinished( self.TitleShadow, {} )
				
				self.Title:completeAnimation() 
				self.Title:setAlpha( 0 ) 
				self.clipFinished( self.Title, {} )
				
				self.TitleDivider:completeAnimation() 
				self.TitleDivider:setAlpha( 0 ) 
				self.clipFinished( self.TitleDivider, {} )
				
				self.HeaderBG:completeAnimation() 
				self.HeaderBG:setAlpha( 0 ) 
				self.clipFinished( self.HeaderBG, {} )
				
				self.Team1BG:completeAnimation() 
				self.Team1BG:setAlpha( 0 ) 
				self.clipFinished( self.Team1BG, {} )
				
				self.Player1BG:completeAnimation() 
				self.Player1BG:setAlpha( 0 ) 
				self.clipFinished( self.Player1BG, {} )
				
				self.Player2BG:completeAnimation() 
				self.Player2BG:setAlpha( 0 ) 
				self.clipFinished( self.Player2BG, {} )
				
				self.Player3BG:completeAnimation() 
				self.Player3BG:setAlpha( 0 ) 
				self.clipFinished( self.Player3BG, {} )
				
				self.Player4BG:completeAnimation() 
				self.Player4BG:setAlpha( 0 ) 
				self.clipFinished( self.Player4BG, {} )
				
				self.MatchTime:completeAnimation() 
				self.MatchTime:setAlpha( 0 ) 
				self.clipFinished( self.MatchTime, {} )
				
				self.Time:completeAnimation() 
				self.Time:setAlpha( 0 ) 
				self.clipFinished( self.Time, {} )
				
				self.SelfMainBG:completeAnimation() 
				self.SelfMainBG:setAlpha( 0 ) 
				self.clipFinished( self.SelfMainBG, {} )
				
				self.SelfCardBG:completeAnimation() 
				self.SelfCardBG:setAlpha( 0 ) 
				self.clipFinished( self.SelfCardBG, {} )
				
				self.SelfNameShadow:completeAnimation() 
				self.SelfNameShadow:setAlpha( 0 ) 
				self.clipFinished( self.SelfNameShadow, {} )
				
				self.SelfName:completeAnimation() 
				self.SelfName:setAlpha( 0 ) 
				self.clipFinished( self.SelfName, {} )
				
				self.SelfCallingCard:completeAnimation() 
				self.SelfCallingCard:setAlpha( 0 ) 
				self.clipFinished( self.SelfCallingCard, {} )
				
				self.SelfEmblem:completeAnimation() 
				self.SelfEmblem:setAlpha( 0 ) 
				self.clipFinished( self.SelfEmblem, {} )
				
				self.SelfRankIcon:completeAnimation() 
				self.SelfRankIcon:setAlpha( 0 ) 
				self.clipFinished( self.SelfRankIcon, {} )
				
				self.SelfScoreIcon:completeAnimation() 
				self.SelfScoreIcon:setAlpha( 0 ) 
				self.clipFinished( self.SelfScoreIcon, {} )
				
				self.SelfScoreTitle:completeAnimation() 
				self.SelfScoreTitle:setAlpha( 0 ) 
				self.clipFinished( self.SelfScoreTitle, {} )
				
				self.SelfScoreText:completeAnimation() 
				self.SelfScoreText:setAlpha( 0 ) 
				self.clipFinished( self.SelfScoreText, {} )
				
				self.SelfJunkIcon:completeAnimation() 
				self.SelfJunkIcon:setAlpha( 0 ) 
				self.clipFinished( self.SelfJunkIcon, {} )
				
				self.SelfJunkTitle:completeAnimation() 
				self.SelfJunkTitle:setAlpha( 0 ) 
				self.clipFinished( self.SelfJunkTitle, {} )
				
				self.SelfJunkText:completeAnimation() 
				self.SelfJunkText:setAlpha( 0 ) 
				self.clipFinished( self.SelfJunkText, {} )
				
				self.ScoreColumn0:completeAnimation() 
				self.ScoreColumn0:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn0, {} )
				
				self.ScoreColumn1:completeAnimation() 
				self.ScoreColumn1:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn1, {} )
				
				self.ScoreColumn2:completeAnimation() 
				self.ScoreColumn2:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn2, {} )
				
				self.ScoreColumn3:completeAnimation() 
				self.ScoreColumn3:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn3, {} )
				
				self.ScoreColumn4:completeAnimation() 
				self.ScoreColumn4:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn4, {} )
				
				self.ScoreColumn5:completeAnimation() 
				self.ScoreColumn5:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn5, {} )
				
				self.ScoreColumn6:completeAnimation() 
				self.ScoreColumn6:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn6, {} )
				
				self.ScoreColumn7:completeAnimation() 
				self.ScoreColumn7:setAlpha( 0 ) 
				self.clipFinished( self.ScoreColumn7, {} )
				
				self.Team1:completeAnimation() 
				self.Team1:setAlpha( 0 ) 
				self.clipFinished( self.Team1, {} )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 38 )

				self.Background:completeAnimation() 
				self.Background:setAlpha( 0.5 ) 
				self.clipFinished( self.Background, {} )
				
				self.T10ScoreboardInventory:completeAnimation() 
				self.T10ScoreboardInventory:setAlpha( 1 ) 
				self.clipFinished( self.T10ScoreboardInventory, {} )
				
				self.RoundIcon:completeAnimation() 
				self.RoundIcon:setAlpha( 1 ) 
				self.clipFinished( self.RoundIcon, {} )
				
				self.RoundTextShadow:completeAnimation() 
				self.RoundTextShadow:setAlpha( 1 ) 
				self.clipFinished( self.RoundTextShadow, {} )
				
				self.RoundText:completeAnimation() 
				self.RoundText:setAlpha( 1 ) 
				self.clipFinished( self.RoundText, {} )
				
				self.TitleShadow:completeAnimation() 
				self.TitleShadow:setAlpha( 1 ) 
				self.clipFinished( self.TitleShadow, {} )
				
				self.Title:completeAnimation() 
				self.Title:setAlpha( 1 ) 
				self.clipFinished( self.Title, {} )
				
				self.TitleDivider:completeAnimation() 
				self.TitleDivider:setAlpha( 1 ) 
				self.clipFinished( self.TitleDivider, {} )
				
				self.HeaderBG:completeAnimation() 
				self.HeaderBG:setAlpha( 1 ) 
				self.clipFinished( self.HeaderBG, {} )
				
				self.Team1BG:completeAnimation() 
				self.Team1BG:setAlpha( 0.75 ) 
				self.clipFinished( self.Team1BG, {} )
				
				self.Player1BG:completeAnimation() 
				self.Player1BG:setAlpha( 1 ) 
				self.clipFinished( self.Player1BG, {} )
				
				self.Player2BG:completeAnimation() 
				self.Player2BG:setAlpha( 1 ) 
				self.clipFinished( self.Player2BG, {} )
				
				self.Player3BG:completeAnimation() 
				self.Player3BG:setAlpha( 1 ) 
				self.clipFinished( self.Player3BG, {} )
				
				self.Player4BG:completeAnimation() 
				self.Player4BG:setAlpha( 1 ) 
				self.clipFinished( self.Player4BG, {} )
				
				self.MatchTime:completeAnimation() 
				self.MatchTime:setAlpha( 1 ) 
				self.clipFinished( self.MatchTime, {} )
				
				self.Time:completeAnimation() 
				self.Time:setAlpha( 1 ) 
				self.clipFinished( self.Time, {} )
				
				self.SelfMainBG:completeAnimation() 
				self.SelfMainBG:setAlpha( 1 ) 
				self.clipFinished( self.SelfMainBG, {} )
				
				self.SelfCardBG:completeAnimation() 
				self.SelfCardBG:setAlpha( 1 ) 
				self.clipFinished( self.SelfCardBG, {} )
				
				self.SelfNameShadow:completeAnimation() 
				self.SelfNameShadow:setAlpha( 1 ) 
				self.clipFinished( self.SelfNameShadow, {} )
				
				self.SelfName:completeAnimation() 
				self.SelfName:setAlpha( 1 ) 
				self.clipFinished( self.SelfName, {} )
				
				self.SelfCallingCard:completeAnimation() 
				self.SelfCallingCard:setAlpha( 1 ) 
				self.clipFinished( self.SelfCallingCard, {} )
				
				self.SelfEmblem:completeAnimation() 
				self.SelfEmblem:setAlpha( 1 ) 
				self.clipFinished( self.SelfEmblem, {} )
				
				self.SelfRankIcon:completeAnimation() 
				self.SelfRankIcon:setAlpha( 1 ) 
				self.clipFinished( self.SelfRankIcon, {} )
				
				self.SelfScoreIcon:completeAnimation() 
				self.SelfScoreIcon:setAlpha( 1 ) 
				self.clipFinished( self.SelfScoreIcon, {} )
				
				self.SelfScoreTitle:completeAnimation() 
				self.SelfScoreTitle:setAlpha( 1 ) 
				self.clipFinished( self.SelfScoreTitle, {} )
				
				self.SelfScoreText:completeAnimation() 
				self.SelfScoreText:setAlpha( 1 ) 
				self.clipFinished( self.SelfScoreText, {} )
				
				self.SelfJunkIcon:completeAnimation() 
				self.SelfJunkIcon:setAlpha( 1 ) 
				self.clipFinished( self.SelfJunkIcon, {} )
				
				self.SelfJunkTitle:completeAnimation() 
				self.SelfJunkTitle:setAlpha( 1 ) 
				self.clipFinished( self.SelfJunkTitle, {} )
				
				self.SelfJunkText:completeAnimation() 
				self.SelfJunkText:setAlpha( 1 ) 
				self.clipFinished( self.SelfJunkText, {} )
				
				self.ScoreColumn0:completeAnimation() 
				self.ScoreColumn0:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn0, {} )
				
				self.ScoreColumn1:completeAnimation() 
				self.ScoreColumn1:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn1, {} )
				
				self.ScoreColumn2:completeAnimation() 
				self.ScoreColumn2:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn2, {} )
				
				self.ScoreColumn3:completeAnimation() 
				self.ScoreColumn3:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn3, {} )
				
				self.ScoreColumn4:completeAnimation() 
				self.ScoreColumn4:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn4, {} )
				
				self.ScoreColumn5:completeAnimation() 
				self.ScoreColumn5:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn5, {} )
				
				self.ScoreColumn6:completeAnimation() 
				self.ScoreColumn6:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn6, {} )
				
				self.ScoreColumn7:completeAnimation() 
				self.ScoreColumn7:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn7, {} )
				
				self.Team1:completeAnimation() 
				self.Team1:setAlpha( 1 ) 
				self.clipFinished( self.Team1, {} )
			end
		},
		ForceVisible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 38 )

				self.Background:completeAnimation() 
				self.Background:setAlpha( 0.5 ) 
				self.clipFinished( self.Background, {} )
				
				self.T10ScoreboardInventory:completeAnimation() 
				self.T10ScoreboardInventory:setAlpha( 1 ) 
				self.clipFinished( self.T10ScoreboardInventory, {} )
				
				self.RoundIcon:completeAnimation() 
				self.RoundIcon:setAlpha( 1 ) 
				self.clipFinished( self.RoundIcon, {} )
				
				self.RoundTextShadow:completeAnimation() 
				self.RoundTextShadow:setAlpha( 1 ) 
				self.clipFinished( self.RoundTextShadow, {} )
				
				self.RoundText:completeAnimation() 
				self.RoundText:setAlpha( 1 ) 
				self.clipFinished( self.RoundText, {} )
				
				self.TitleShadow:completeAnimation() 
				self.TitleShadow:setAlpha( 1 ) 
				self.clipFinished( self.TitleShadow, {} )
				
				self.Title:completeAnimation() 
				self.Title:setAlpha( 1 ) 
				self.clipFinished( self.Title, {} )
				
				self.TitleDivider:completeAnimation() 
				self.TitleDivider:setAlpha( 1 ) 
				self.clipFinished( self.TitleDivider, {} )
				
				self.HeaderBG:completeAnimation() 
				self.HeaderBG:setAlpha( 1 ) 
				self.clipFinished( self.HeaderBG, {} )
				
				self.Team1BG:completeAnimation() 
				self.Team1BG:setAlpha( 0.75 ) 
				self.clipFinished( self.Team1BG, {} )
				
				self.Player1BG:completeAnimation() 
				self.Player1BG:setAlpha( 1 ) 
				self.clipFinished( self.Player1BG, {} )
				
				self.Player2BG:completeAnimation() 
				self.Player2BG:setAlpha( 1 ) 
				self.clipFinished( self.Player2BG, {} )
				
				self.Player3BG:completeAnimation() 
				self.Player3BG:setAlpha( 1 ) 
				self.clipFinished( self.Player3BG, {} )
				
				self.Player4BG:completeAnimation() 
				self.Player4BG:setAlpha( 1 ) 
				self.clipFinished( self.Player4BG, {} )
				
				self.MatchTime:completeAnimation() 
				self.MatchTime:setAlpha( 1 ) 
				self.clipFinished( self.MatchTime, {} )
				
				self.Time:completeAnimation() 
				self.Time:setAlpha( 1 ) 
				self.clipFinished( self.Time, {} )
				
				self.SelfMainBG:completeAnimation() 
				self.SelfMainBG:setAlpha( 1 ) 
				self.clipFinished( self.SelfMainBG, {} )
				
				self.SelfCardBG:completeAnimation() 
				self.SelfCardBG:setAlpha( 1 ) 
				self.clipFinished( self.SelfCardBG, {} )
				
				self.SelfNameShadow:completeAnimation() 
				self.SelfNameShadow:setAlpha( 1 ) 
				self.clipFinished( self.SelfNameShadow, {} )
				
				self.SelfName:completeAnimation() 
				self.SelfName:setAlpha( 1 ) 
				self.clipFinished( self.SelfName, {} )
				
				self.SelfCallingCard:completeAnimation() 
				self.SelfCallingCard:setAlpha( 1 ) 
				self.clipFinished( self.SelfCallingCard, {} )
				
				self.SelfEmblem:completeAnimation() 
				self.SelfEmblem:setAlpha( 1 ) 
				self.clipFinished( self.SelfEmblem, {} )
				
				self.SelfRankIcon:completeAnimation() 
				self.SelfRankIcon:setAlpha( 1 ) 
				self.clipFinished( self.SelfRankIcon, {} )
				
				self.SelfScoreIcon:completeAnimation() 
				self.SelfScoreIcon:setAlpha( 1 ) 
				self.clipFinished( self.SelfScoreIcon, {} )
				
				self.SelfScoreTitle:completeAnimation() 
				self.SelfScoreTitle:setAlpha( 1 ) 
				self.clipFinished( self.SelfScoreTitle, {} )
				
				self.SelfScoreText:completeAnimation() 
				self.SelfScoreText:setAlpha( 1 ) 
				self.clipFinished( self.SelfScoreText, {} )
				
				self.SelfJunkIcon:completeAnimation() 
				self.SelfJunkIcon:setAlpha( 1 ) 
				self.clipFinished( self.SelfJunkIcon, {} )
				
				self.SelfJunkTitle:completeAnimation() 
				self.SelfJunkTitle:setAlpha( 1 ) 
				self.clipFinished( self.SelfJunkTitle, {} )
				
				self.SelfJunkText:completeAnimation() 
				self.SelfJunkText:setAlpha( 1 ) 
				self.clipFinished( self.SelfJunkText, {} )
				
				self.ScoreColumn0:completeAnimation() 
				self.ScoreColumn0:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn0, {} )
				
				self.ScoreColumn1:completeAnimation() 
				self.ScoreColumn1:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn1, {} )
				
				self.ScoreColumn2:completeAnimation() 
				self.ScoreColumn2:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn2, {} )
				
				self.ScoreColumn3:completeAnimation() 
				self.ScoreColumn3:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn3, {} )
				
				self.ScoreColumn4:completeAnimation() 
				self.ScoreColumn4:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn4, {} )
				
				self.ScoreColumn5:completeAnimation() 
				self.ScoreColumn5:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn5, {} )
				
				self.ScoreColumn6:completeAnimation() 
				self.ScoreColumn6:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn6, {} )
				
				self.ScoreColumn7:completeAnimation() 
				self.ScoreColumn7:setAlpha( 1 ) 
				self.clipFinished( self.ScoreColumn7, {} )
				
				self.Team1:completeAnimation() 
				self.Team1:setAlpha( 1 ) 
				self.clipFinished( self.Team1, {} )
			end
		}
	}
	
	self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				return Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
			end
		},
		{
			stateName = "ForceVisible",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "forceScoreboard", 1 )
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "forceScoreboard" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "forceScoreboard"
		} )
	end )

	self.Team1.id = "Team1"

	self:registerEventHandler( "gain_focus", function ( self, event )
		if self.m_focusable and self.Team1:processEvent( event ) then
			return true
		else
			return LUI.UIElement.gainFocus( self, event )
		end
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Background:close()
		element.T10ScoreboardInventory:close()
		element.RoundIcon:close()
		element.RoundTextShadow:close()
		element.RoundText:close()
		element.TitleShadow:close()
		element.Title:close()
		element.TitleDivider:close()
		element.HeaderBG:close()
		element.Team1BG:close()
		element.Player1BG:close()
		element.Player2BG:close()
		element.Player3BG:close()
		element.Player4BG:close()
		element.MatchTime:close()
		element.Time:close()
		element.SelfMainBG:close()
		element.SelfCardBG:close()
		element.SelfNameShadow:close()
		element.SelfName:close()
		element.SelfCallingCard:close()
		element.SelfEmblem:close()
		element.SelfRankIcon:close()
		element.SelfScoreIcon:close()
		element.SelfScoreTitle:close()
		element.SelfScoreText:close()
		element.SelfJunkIcon:close()
		element.SelfJunkTitle:close()
		element.SelfJunkText:close()
		element.ScoreColumn0:close()
		element.ScoreColumn1:close()
		element.ScoreColumn2:close()
		element.ScoreColumn3:close()
		element.ScoreColumn4:close()
		element.ScoreColumn5:close()
		element.ScoreColumn6:close()
		element.ScoreColumn7:close()
		element.Team1:close()
	end )

	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end

	return self
end
