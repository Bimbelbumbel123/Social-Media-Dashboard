// src/main.ts
import { bootstrapApplication } from '@angular/platform-browser';
import { provideHttpClient } from '@angular/common/http';
import { DashboardComponent } from './app/dashboard/dashboard.component';
import 'zone.js';

bootstrapApplication(DashboardComponent, {
  providers: [provideHttpClient()]
}).catch(err => console.error(err));
