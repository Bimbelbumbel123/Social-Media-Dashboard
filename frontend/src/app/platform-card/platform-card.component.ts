import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Account } from "../dashboard/dashboard.component";

@Component({
  selector: 'app-platform-card',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './platform-card.component.html',
  styleUrls: ['./platform-card.component.scss']
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
    return icons[platform] || 'https://simpleicons.org/generic/white';
  }
}
