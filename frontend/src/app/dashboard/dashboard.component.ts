import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlatformCardComponent } from "../platform-card/platform-card.component";
import { StatChartComponent } from "../stat-chart/stat-chart.component";

export interface Account {
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
  imports: [CommonModule, PlatformCardComponent, StatChartComponent],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent {
  accounts: Account[] = [
    { platform: 'YouTube', followers: 125000, growth: 12.5 },
    { platform: 'TikTok', followers: 89000, growth: 24.3 },
    { platform: 'Instagram', followers: 156000, growth: 8.7 },
    { platform: 'Twitch', followers: 45000, growth: -3.2 }
  ];

  chartData: ChartData[] = [
    { month: 'Jan', YouTube: 95000, TikTok: 55000, Instagram: 120000, Twitch: 48000 },
    { month: 'Feb', YouTube: 102000, TikTok: 62000, Instagram: 128000, Twitch: 47000 },
    { month: 'Mar', YouTube: 108000, TikTok: 71000, Instagram: 135000, Twitch: 46500 },
    { month: 'Apr', YouTube: 115000, TikTok: 78000, Instagram: 142000, Twitch: 46000 },
    { month: 'May', YouTube: 120000, TikTok: 84000, Instagram: 148000, Twitch: 45500 },
    { month: 'Jun', YouTube: 125000, TikTok: 89000, Instagram: 156000, Twitch: 45000 }
  ];
  protected let: any;
  protected account: any;

  get totalFollowers(): number {
    return this.accounts.reduce((sum, acc) => sum + acc.followers, 0);
  }

  get avgGrowth(): number {
    const sum = this.accounts.reduce((total, acc) => total + acc.growth, 0);
    return Math.round((sum / this.accounts.length) * 10) / 10;
  }
}
