/*
 * Copyright (C) 2021 ~ 2022 UnionTech Technology Co., Ltd.
 *
 * Author:     JiDe Zhang <zhangjide@deepin.org>
 *
 * Maintainer: JiDe Zhang <zhangjide@deepin.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import QtQuick.Templates 2.4 as T
import org.deepin.dtk.impl 1.0 as D
import org.deepin.dtk.style 1.0 as DS
import QtGraphicalEffects 1.0

T.Button {
    id: control

    property D.Palette color1: highlighted ? DS.Style.suggestButton1 : DS.Style.button1
    property D.Palette color2: highlighted ? DS.Style.suggestButton2 : DS.Style.button2
    property D.Palette textColor: highlighted ? DS.Style.suggestButtonText : DS.Style.buttonText
    property D.Palette borderColor: highlighted ? DS.Style.suggestButtonBorder : DS.Style.buttonBorder

    implicitWidth: DS.Style.control.implicitWidth(control)
    implicitHeight: DS.Style.control.implicitHeight(control)

    topPadding: DS.Style.control.vPadding
    bottomPadding: DS.Style.control.vPadding
    spacing: DS.Style.control.spacing
    opacity: enabled ? 1 : 0.4
    D.DciIcon.mode: D.ColorSelector.controlState
    icon {
        width: DS.Style.button.iconSize
        height: DS.Style.button.iconSize
        color: D.ColorSelector.textColor
    }

    background: Item {
        id: backgroundItem
        objectName: "ColorSelectorMaster"
        implicitWidth: DS.Style.button.width
        implicitHeight: DS.Style.button.height
        visible: !control.flat || control.down || control.checked || control.highlighted || control.visualFocus || control.hovered
        D.ColorSelector.hovered: false

        RectangularGlow {
            anchors.fill: backgroundRect
            glowRadius: 10
            color: palette.shadow
            cornerRadius: backgroundRect.radius
        }

        Gradient {
            id: backgroundGradient
            // Use the backgroundItem's colorselecor can filter the hovered state.
            GradientStop { position: 0.0; color: backgroundItem.D.ColorSelector.color1}
            GradientStop { position: 0.96; color: backgroundItem.D.ColorSelector.color2}
        }

        Rectangle {
            id: backgroundRect
            property D.Palette color1: D.Palette {
                enabled: control.checked
                normal: control.palette.highlight
                hovered: D.DTK.adjustColor(control.palette.highlight, 0, 0, +10, 0, 0, 0, 0)
                pressed: D.DTK.adjustColor(control.palette.highlight, 0, 0, -10, 0, 0, 0, 0)
            }

            anchors.fill: parent
            radius: DS.Style.control.radius
            border {
                width: DS.Style.control.borderWidth
                color: D.ColorSelector.borderColor
            }
            gradient: control.checked ? null : backgroundGradient
            color: D.ColorSelector.color1
        }

        Gradient {
            id: hoverBackgroundGradient
            GradientStop { position: 0.0; color: control.D.ColorSelector.color1 }
            GradientStop { position: 0.96; color: control.D.ColorSelector.color2 }
        }

        CicleSpreadAnimation {
            id: hoverAnimation
            anchors.fill: backgroundRect
            visible: control.D.ColorSelector.controlState === D.DTK.HoveredState

            Rectangle {
                anchors.fill: parent
                radius: backgroundRect.radius
                border {
                    width: backgroundRect.border.width
                    color: backgroundRect.border.color
                }
                gradient: control.checked ? null : hoverBackgroundGradient
                color: backgroundRect.color
            }
        }
    }

    onHoveredChanged: {
        if (!hoverAnimation)
            return

        if (hovered) {
            var pos = D.DTK.cursorPosition()
            hoverAnimation.centerPoint = hoverAnimation.mapFromGlobal(pos.x, pos.y)
            hoverAnimation.start()
        } else {
            hoverAnimation.stop()
        }
    }

    contentItem: D.IconLabel {
        property D.Palette textColor: D.Palette {
            enabled: control.checked
            normal: control.palette.highlightedText
            hovered: D.DTK.adjustColor(control.palette.highlightedText, 0, 0, +10, 0, 0, 0, 0)
            pressed: D.DTK.adjustColor(control.palette.highlightedText, 0, 0, -20, 0, 0, 0, 0)
        }

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        text: control.text
        font: control.font
        color: D.ColorSelector.textColor
        icon: D.DTK.makeIcon(control.icon, control.D.DciIcon)
    }
}

