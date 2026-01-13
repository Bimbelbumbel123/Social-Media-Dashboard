import { Component, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { PlatformCardComponent } from '../platform-card/platform-card.component';
import { StatChartComponent } from '../stat-chart/stat-chart.component';
import { MatCardModule } from '@angular/material/card';

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
    MatCardModule
  ],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {
  constructor() {
    console.log('Dashboard loaded');
  }


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




  get totalFollowers(): number {
    return this.accounts.reduce((sum, acc) => sum + acc.followers, 0);
  }

  get avgGrowth(): number {
    const sum = this.accounts.reduce((total, acc) => total + acc.growth, 0);
    return Math.round((sum / this.accounts.length) * 10) / 10;
  }

  trackById(index: number, account: Account): number {
    return account.id;
  }

  isYoutubeConnected = signal(this.accounts.some(acc => acc.platform === "YouTube"));
  connectYoutube() {
    window.location.href = "http://localhost:3001/auth/google_oauth2";
  }

  checkConnections(accounts: Account[]) {
    this.isYoutubeConnected.set(accounts.some(acc => acc.platform === "YouTube"));
  }

  loadDashboard() {
    fetch('http://localhost:3001/api/v1/dashboard')
      .then(res => res.json())
      .then(data => {

        this.checkConnections(data);
      })
      .catch(err => console.error('Error occurred while loading dashboards', err));
  }

  ngOnInit() {
    this.loadDashboard();
  }
}
