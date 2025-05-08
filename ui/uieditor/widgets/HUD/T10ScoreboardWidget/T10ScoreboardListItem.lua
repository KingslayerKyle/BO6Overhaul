CoD.T10ScoreboardListItem = InheritFrom( LUI.UIElement )
CoD.T10ScoreboardListItem.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10ScoreboardListItem )
	self.id = "T10ScoreboardListItem"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1033 )
	self:setTopBottom( true, false, 0, 33.5 )
	self:makeFocusable()
	self:setHandleMouse( true )
	self.anyChildUsesUpdateState = true

	self.FocusBar = LUI.UIImage.new()
	self.FocusBar:setLeftRight( true, true, 0, 0 )
	self.FocusBar:setTopBottom( true, true, 0, 0 )
	self.FocusBar:setImage( RegisterImage( "$white" ) )
	self.FocusBar:setRGB( 1.00, 0.91, 0.39 )
	self.FocusBar:setAlpha( 0 )
	self:addElement( self.FocusBar )

	self.FocusBarT = LUI.UIImage.new()
	self.FocusBarT:setLeftRight( true, true, 0, 0 )
	self.FocusBarT:setTopBottom( true, false, 0, 1 )
	self.FocusBarT:setImage( RegisterImage( "$white" ) )
	self.FocusBarT:setRGB( 1.00, 0.91, 0.39 )
	self.FocusBarT:setAlpha( 0 )
	self:addElement( self.FocusBarT )

	self.FocusBarB = LUI.UIImage.new()
	self.FocusBarB:setLeftRight( true, true, 0, 0 )
	self.FocusBarB:setTopBottom( false, true, -1, 0 )
	self.FocusBarB:setImage( RegisterImage( "$white" ) )
	self.FocusBarB:setRGB( 1.00, 0.91, 0.39 )
	self.FocusBarB:setAlpha( 0 )
	self:addElement( self.FocusBarB )

	self.FocusBarL = LUI.UIImage.new()
	self.FocusBarL:setLeftRight( true, false, 0, 1 )
	self.FocusBarL:setTopBottom( true, true, 0, 0 )
	self.FocusBarL:setImage( RegisterImage( "$white" ) )
	self.FocusBarL:setRGB( 1.00, 0.91, 0.39 )
	self.FocusBarL:setAlpha( 0 )
	self:addElement( self.FocusBarL )

	self.FocusBarR = LUI.UIImage.new()
	self.FocusBarR:setLeftRight( false, true, 0, -1 )
	self.FocusBarR:setTopBottom( true, true, 0, 0 )
	self.FocusBarR:setImage( RegisterImage( "$white" ) )
	self.FocusBarR:setRGB( 1.00, 0.91, 0.39 )
	self.FocusBarR:setAlpha( 0 )
	self:addElement( self.FocusBarR )

	self.RankIcon = LUI.UIImage.new()
	self.RankIcon:setLeftRight( true, false, 197 - 130 - 7, 210 - 130 + 7 )
	self.RankIcon:setTopBottom( true, false, 10.5 - 7, 23.5 + 7 )
	self.RankIcon:setImage( RegisterImage( "blacktransparent" ) )
	self.RankIcon:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			local controllerModel = Engine.GetModelForController( controller )
			local playerConnectedModel = Engine.GetModel( controllerModel, "PlayerList." .. clientNum .. ".playerConnected" )

			if playerConnectedModel then
				self.RankIcon:setImage( RegisterImage( "t4_icon_rank_mp_prestige_10" ) )
			else
				self.RankIcon:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.RankIcon )

	self.Circle = LUI.UIImage.new()
	self.Circle:setLeftRight( true, false, 197, 210 )
	self.Circle:setTopBottom( true, false, 10.5, 23.5 )
	self.Circle:setImage( RegisterImage( "blacktransparent" ) )
	self.Circle:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			local controllerModel = Engine.GetModelForController( controller )
			local playerConnectedModel = Engine.GetModel( controllerModel, "PlayerList." .. clientNum .. ".playerConnected" )

			if playerConnectedModel then
				self.Circle:setImage( RegisterImage( "ximage_c4366da49b7c910" ) )
			else
				self.Circle:setImage( RegisterImage( "blacktransparent" ) )
			end

			self.Circle:setRGB( ZombieClientScoreboardColor( clientNum ) )
		end
	end )
	self:addElement( self.Circle )

	self.ScoreColumn0 = LUI.UIText.new()
	self.ScoreColumn0:setLeftRight( true, true, -327.5, 0 )
	self.ScoreColumn0:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn0:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.ScoreColumn0:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn0:setScale( 0.5 )
	self.ScoreColumn0:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn0:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			local controllerModel = Engine.GetModelForController( controller )
			local playerConnectedModel = Engine.GetModel( controllerModel, "PlayerList." .. clientNum .. ".playerConnected" )

			if playerConnectedModel then
				self.ScoreColumn0:setText( Engine.Localize( clientNum + 1 ) )
			else
				self.ScoreColumn0:setText( Engine.Localize( "" ) )
			end
		end
	end )
	self:addElement( self.ScoreColumn0 )

	self.ScoreColumn1 = LUI.UIText.new()
	self.ScoreColumn1:setLeftRight( true, true, -225, 0 )
	self.ScoreColumn1:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn1:setText( Engine.Localize( "" ) )
	self.ScoreColumn1:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.ScoreColumn1:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn1:setScale( 0.5 )
	self.ScoreColumn1:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn1:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			local controllerModel = Engine.GetModelForController( controller )
			local playerConnectedModel = Engine.GetModel( controllerModel, "PlayerList." .. clientNum .. ".playerConnected" )

			if playerConnectedModel then
				self.ScoreColumn1:setText( Engine.Localize( "55" ) )
			else
				self.ScoreColumn1:setText( Engine.Localize( "" ) )
			end
		end
	end )
	self:addElement( self.ScoreColumn1 )

	self.ScoreColumn2 = LUI.UIText.new()
	self.ScoreColumn2:setLeftRight( true, true, -55, 0 )
	self.ScoreColumn2:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn2:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.ScoreColumn2:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn2:setScale( 0.5 )
	self.ScoreColumn2:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn2:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			self.ScoreColumn2:setText( Engine.Localize( GetClientName( controller, clientNum ) ) )
		end
	end )
	self:addElement( self.ScoreColumn2 )

	self.ScoreColumn3 = LUI.UIText.new()
	self.ScoreColumn3:setLeftRight( true, true, -55 + 224, 0 + 224 )
	self.ScoreColumn3:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn3:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.ScoreColumn3:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn3:setScale( 0.5 )
	self.ScoreColumn3:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn3:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( model )
		local score = Engine.GetModelValue( model )

		if score then
			self.ScoreColumn3:setText( Engine.Localize( GetScoreboardPlayerScoreColumn( controller, 0, score ) ) )
		end
	end )
	self:addElement( self.ScoreColumn3 )

	self.ScoreColumn4 = LUI.UIText.new()
	self.ScoreColumn4:setLeftRight( true, true, -55 + 360, 0 + 360 )
	self.ScoreColumn4:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn4:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.ScoreColumn4:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn4:setScale( 0.5 )
	self.ScoreColumn4:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn4:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( model )
		local kills = Engine.GetModelValue( model )

		if kills then
			self.ScoreColumn4:setText( Engine.Localize( GetScoreboardPlayerScoreColumn( controller, 1, kills ) ) )
		end
	end )
	self:addElement( self.ScoreColumn4 )
	
	self.ScoreColumn5 = LUI.UIText.new()
	self.ScoreColumn5:setLeftRight( true, true, -55 + 485, 0 + 485 )
	self.ScoreColumn5:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn5:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.ScoreColumn5:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn5:setScale( 0.5 )
	self.ScoreColumn5:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn5:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( model )
		local headshots = Engine.GetModelValue( model )

		if headshots then
			self.ScoreColumn5:setText( Engine.Localize( GetScoreboardPlayerScoreColumn( controller, 4, headshots ) ) )
		end
	end )
	self:addElement( self.ScoreColumn5 )
	
	self.ScoreColumn6 = LUI.UIText.new()
	self.ScoreColumn6:setLeftRight( true, true, -55 + 610.5, 0 + 610.5 )
	self.ScoreColumn6:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn6:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.ScoreColumn6:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn6:setScale( 0.5 )
	self.ScoreColumn6:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn6:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( model )
		local revives = Engine.GetModelValue( model )

		if revives then
			self.ScoreColumn6:setText( Engine.Localize( GetScoreboardPlayerScoreColumn( controller, 3, revives ) ) )
		end
	end )
	self:addElement( self.ScoreColumn6 )
	
	self.ScoreColumn7 = LUI.UIText.new()
	self.ScoreColumn7:setLeftRight( true, true, 55 + 653, 0 + 653 )
	self.ScoreColumn7:setTopBottom( true, false, -1.5, 35.5 )
	self.ScoreColumn7:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.ScoreColumn7:setRGB( 0.85, 0.79, 0.70 )
	self.ScoreColumn7:setScale( 0.5 )
	self.ScoreColumn7:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreColumn7:linkToElementModel( self, "clientNumScoreInfoUpdated", true, function ( model )
		local downs = Engine.GetModelValue( model )

		if downs then
			self.ScoreColumn7:setText( Engine.Localize( GetScoreboardPlayerScoreColumn( controller, 2, downs ) ) )
		end
	end )
	self:addElement( self.ScoreColumn7 )
	
	self.PingText = LUI.UIText.new()
	self.PingText:setLeftRight( true, true, 55 + 740, 0 + 740 )
	self.PingText:setTopBottom( true, false, -1.5, 35.5 )
	self.PingText:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.PingText:setRGB( 0.85, 0.79, 0.70 )
	self.PingText:setScale( 0.5 )
	self.PingText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.PingText:linkToElementModel( self, "ping", true, function ( model )
		local ping = Engine.GetModelValue( model )

		if ping then
			if ping > 1 then
				self.PingText:setText( "PING: " .. Engine.Localize( ping ) )
			end
		end
	end )
	self:addElement( self.PingText )
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )

				self.FocusBar:completeAnimation()
				self.FocusBar:setAlpha( 0 )
				self.clipFinished( self.FocusBar, {} )

				self.FocusBarT:completeAnimation()
				self.FocusBarT:setAlpha( 0 )
				self.clipFinished( self.FocusBarT, {} )

				self.FocusBarB:completeAnimation()
				self.FocusBarB:setAlpha( 0 )
				self.clipFinished( self.FocusBarB, {} )

				self.FocusBarL:completeAnimation()
				self.FocusBarL:setAlpha( 0 )
				self.clipFinished( self.FocusBarL, {} )

				self.FocusBarR:completeAnimation()
				self.FocusBarR:setAlpha( 0 )
				self.clipFinished( self.FocusBarR, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 5 )

				self.FocusBar:completeAnimation()
				self.FocusBar:setAlpha( 0.2 )
				self.clipFinished( self.FocusBar, {} )

				self.FocusBarT:completeAnimation()
				self.FocusBarT:setAlpha( 1 )
				self.clipFinished( self.FocusBarT, {} )

				self.FocusBarB:completeAnimation()
				self.FocusBarB:setAlpha( 1 )
				self.clipFinished( self.FocusBarB, {} )

				self.FocusBarL:completeAnimation()
				self.FocusBarL:setAlpha( 1 )
				self.clipFinished( self.FocusBarL, {} )

				self.FocusBarR:completeAnimation()
				self.FocusBarR:setAlpha( 1 )
				self.clipFinished( self.FocusBarR, {} )
			end
		}
	}

	self:linkToElementModel( self, "clientNum", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "clientNum"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "deadSpectator.playerIndex" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "deadSpectator.playerIndex"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.FocusBar:close()
		element.FocusBarT:close()
		element.FocusBarB:close()
		element.FocusBarL:close()
		element.FocusBarR:close()
		element.RankIcon:close()
		element.Circle:close()
		element.ScoreColumn0:close()
		element.ScoreColumn1:close()
		element.ScoreColumn2:close()
		element.ScoreColumn3:close()
		element.ScoreColumn4:close()
		element.ScoreColumn5:close()
		element.ScoreColumn6:close()
		element.ScoreColumn7:close()
		element.PingText:close()
	end )

	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end

	return self
end
