import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Account } from "../dashboard/dashboard.component";

@Component({
  selector: 'app-platform-card',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './platform-card.component.html'
})
export class PlatformCardComponent {
  @Input() account!: Account;

  getPlatformIcon(platform: string): string {
    const icons: Record<string, string> = {
      YouTube: 'https://cdn.simpleicons.org/youtube/white',
      TikTok: 'https://cdn.simpleicons.org/tiktok/white',
      Instagram: 'https://cdn.simpleicons.org/instagram/white',
      Twitch: 'https://cdn.simpleicons.org/twitch/white'
    };
    return icons[platform] || 'https://cdn.simpleicons.org/generic/white';
  }

  getPlatformColor(platform: string): string {
    const colors: Record<string, string> = {
      YouTube: 'from-red-500 to-red-600',
      TikTok: 'from-pink-500 to-purple-600',
      Instagram: 'from-purple-500 to-pink-500',
      Twitch: 'from-purple-600 to-purple-700'
    };
    return colors[platform] || 'from-gray-500 to-gray-600';
  }
}
