import { Component, OnInit } from '@angular/core';
import { DashboardService } from '../dashboard_services/dashboard.services';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
})
export class DashboardComponent implements OnInit {
  accounts: any[] = [];
  chartData: any[] = [];

  constructor(private dashboardService: DashboardService) {}

  ngOnInit() {
    this.dashboardService.getAccounts().subscribe(accounts => {
      this.accounts = accounts;

      const dates = new Set<string>();
      accounts.forEach(acc => acc.recent_stats.forEach(s => dates.add(s.date)));
      const sortedDates = Array.from(dates).sort();

      this.chartData = sortedDates.map(date => {
        let followersSum = 0;
        accounts.forEach(acc => {
          const stat = acc.recent_stats.find(s => s.date === date);
          if (stat) followersSum += stat.followers;
        });
        return { date, followers: followersSum };
      });
    });
  }
}
