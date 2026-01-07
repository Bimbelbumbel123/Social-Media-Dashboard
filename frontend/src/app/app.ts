import { Component, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule} from '@angular/common';
import { AccountService, Account } from './services/account'
import { toSignal } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  private accountService = inject(AccountService)

  accounts = toSignal(this.accountService.getAccounts(), { initialValue: [] })
}
