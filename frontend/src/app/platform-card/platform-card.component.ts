import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-platform-card',
  standalone: true,
  templateUrl: './platform-card.component.html'
})
export class PlatformCardComponent {
  @Input() account: any;

  getPlatformIcon(platform: string): string {
    const icons: Record<string, string> = {
      YouTube: 'https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg',
      TikTok: 'https://upload.wikimedia.org/wikipedia/en/a/a9/TikTok_logo.svg',
      Instagram: 'https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg',
      Twitch: 'https://upload.wikimedia.org/wikipedia/commons/3/3f/Twitch_icon.svg'
    };
    return icons[platform] || 'https://cdn-icons-png.flaticon.com/512/25/25231.png';
  }
}
