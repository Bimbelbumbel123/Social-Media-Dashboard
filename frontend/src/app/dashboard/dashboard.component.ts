import { Component, signal, OnInit } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { PlatformCardComponent } from '../platform-card/platform-card.component';
import { StatChartComponent } from '../stat-chart/stat-chart.component';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

export interface Account {
  id: number;
  platform: string;
  followers: number;
  growth: number;
}

export interface ChartData {
  month: string;
  YouTube: number;
  TikTok: number;
  Instagram: number;
  Twitch: number;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    DecimalPipe,
    PlatformCardComponent,
    StatChartComponent,
    MatCardModule,
    MatButtonModule,
    MatIconModule
  ],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  private backendUrl = 'http://localhost:3001';

  accounts: Account[] = [
    { id: 1, platform: 'YouTube', followers: 125000, growth: 12.5 },
    { id: 2, platform: 'TikTok', followers: 89000, growth: 24.3 },
    { id: 3, platform: 'Instagram', followers: 156000, growth: 8.7 },
    { id: 4, platform: 'Twitch', followers: 45000, growth: -3.2 }
  ];

  chartData: ChartData[] = [
    { month: 'Jan', YouTube: 95000, TikTok: 55000, Instagram: 120000, Twitch: 48000 },
    { month: 'Feb', YouTube: 102000, TikTok: 62000, Instagram: 128000, Twitch: 47000 },
    { month: 'Mar', YouTube: 108000, TikTok: 71000, Instagram: 135000, Twitch: 46500 },
    { month: 'Apr', YouTube: 115000, TikTok: 78000, Instagram: 142000, Twitch: 46000 },
    { month: 'May', YouTube: 120000, TikTok: 84000, Instagram: 148000, Twitch: 45500 },
    { month: 'Jun', YouTube: 125000, TikTok: 89000, Instagram: 156000, Twitch: 45000 }
  ];

  isYoutubeConnected = signal(false);
  isTikTokConnected = signal(false);
  isInstagramConnected = signal(false);
  isTwitchConnected = signal(false);

  constructor() {
    console.log('Dashboard loaded');
  }

  ngOnInit() {
    this.loadDashboard();
  }

  connectYoutube() {
    window.location.href = `${this.backendUrl}/auth/google_oauth2`;
  }

  connectTwitch() {
    window.location.href = `${this.backendUrl}/auth/twitch`;
  }

  connectInstagram() {
    window.location.href = `${this.backendUrl}/auth/instagram`;
  }

  connectTiktok() {
    window.location.href = `${this.backendUrl}/auth/tiktok`;
  }

  loadDashboard() {
    fetch(`${this.backendUrl}/api/v1/dashboard`)
      .then(res => res.json())
      .then(data => {
        // Hier würdest du normalerweise this.accounts = data setzen,
        // wenn das Backend bereits die echten Daten liefert.
        this.checkConnections(data);
      })
      .catch(err => console.error('Error occurred while loading dashboard', err));
  }

  checkConnections(accounts: Account[]) {
    this.isYoutubeConnected.set(accounts.some(acc => acc.platform === "YouTube"));
    this.isTikTokConnected.set(accounts.some(acc => acc.platform === "TikTok"));
    this.isInstagramConnected.set(accounts.some(acc => acc.platform === "Instagram"));
    this.isTwitchConnected.set(accounts.some(acc => acc.platform === "Twitch"));
  }

  get totalFollowers(): number {
    return this.accounts.reduce((sum, acc) => sum + acc.followers, 0);
  }

  get avgGrowth(): number {
    if (this.accounts.length === 0) return 0;
    const sum = this.accounts.reduce((total, acc) => total + acc.growth, 0);
    return Math.round((sum / this.accounts.length) * 10) / 10;
  }
}
