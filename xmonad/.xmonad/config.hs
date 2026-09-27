--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe, safeSpawn, unsafeSpawn)
import XMonad.Util.SpawnOnce (spawnOnce)
import Graphics.X11.ExtraTypes.XF86
import Graphics.X11.ExtraTypes.XorgDefault
import Data.Monoid
import System.Exit
import System.IO (hPutStrLn)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- | The preferred terminal program.
myTerminal :: String
myTerminal = "alacritty"

-- | Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- | Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- | Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth = 2

-- | modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask :: KeyMask
myModMask = mod4Mask

-- | The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces :: [String]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

-- | Border color for unfocused windows.
myNormalBorderColor :: String
myNormalBorderColor  = "#ebdbb2"

-- | Border color for the focused window.
myFocusedBorderColor :: String
myFocusedBorderColor = "#8ec07c"

------------------------------------------------------------------------
-- | Key bindings. Add, modify or remove key bindings here.
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- Mod-Shift-Return: launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- Mod-P: launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")
    -- Mod-Shift-P: launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
    -- Mod-Shift-C: close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    -- Mod-Space: Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    -- Mod-Shift-Space: Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Mod-N: Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Mod-Tab: Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Mod-J: Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Mod-K: Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Mod-M: Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Mod-Return: Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    -- Mod-Shift-J: Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Mod-Shift-K: Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Mod-H: Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Mod-L: Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Mod-T: Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Mod-,: Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Mod-.: Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Mod-B: Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Mod-Shift-Q: Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Mod-Q: Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    -- Mod-Shift-/: Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    -- Swap keymaps
    , ((modm .|. shiftMask, xK_x), spawn "setxkbmap ara")
    , ((modm .|. shiftMask, xK_Arabic_hamza), spawn "setxkbmap us intl lv3:caps_switch")
    -- Brightness hotkeys
    , ((noModMask, xF86XK_MonBrightnessDown), spawn ("brightnessctl s 5%-"))
    , ((noModMask, xF86XK_MonBrightnessUp), spawn ("brightnessctl s 5%+"))
    , ((modm, xF86XK_MonBrightnessDown), spawn ("brightnessctl s 1"))
    , ((modm, xF86XK_MonBrightnessUp), spawn ("brightnessctl s 100%"))
    -- Volume hotkeys
    , ((noModMask, xF86XK_AudioMute), spawn ("pamixer -t"))
    , ((noModMask, xF86XK_AudioRaiseVolume), spawn ("pamixer -i 5"))
    , ((noModMask, xF86XK_AudioLowerVolume), spawn ("pamixer -d 5"))
    -- Screen lock
    , ((modm .|. shiftMask, xK_l     ), spawn ("xlock"))
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout = avoidStruts $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook :: ManageHook
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook :: Event -> X All
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook xmproc = dynamicLogWithPP xmobarPP
  { ppOutput = hPutStrLn xmproc
  , ppTitle = xmobarColor "#b8bb26" "" . shorten 100
  }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook :: X ()
myStartupHook = do
  -- setDefaultCursor xC_pirate
  spawnOnce $ "trayer " ++ (unwords ["--edge", "top",
                                     "--align", "right",
                                     "--SetDockType", "true",
                                     "--SetPartialStrut", "true",
                                     "--expand", "true",
                                     "--width", "5",
                                     "--alpha", "0",
                                     "--transparent", "true",
                                     "--tint", "0x282828",
                                     "--height", "17",
                                     "--margin", "0"])
  -- spawnOnce "signal-desktop --start-in-tray"
  -- spawnOnce "slack --startup"
  spawnOnce "nm-applet"
  unsafeSpawn "${HOME}/.scripts/set-background.sh"
  spawnOnce "pasystray"
  spawnOnce "blueman-applet"
  spawnOnce "xinput --set-prop \"AlpsPS/2 ALPS DualPoint Stick\" \"libinput Accel Speed\" 1.0" --Set the trackpoint sensitivity.
  -- safeSpawn "wicd-client" []

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar /home/banert/.xmobarrc"
  xmonad $ docks $ defaults xmproc

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults xmproc = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook, -- <+> docksEventHook,
        logHook            = myLogHook xmproc,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
