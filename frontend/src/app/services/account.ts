import { Injectable } from '@angular/core';
import { HttpClient} from '@angular/common/http';
import { Observable} from 'rxjs';

export interface Account {
  id?: number,
  platform: string,
  username: string,
  likes: number,
  clicks: number,
}

@Injectable({
  providedIn: 'root'
})
export class AccountService {
  private apiUrl = 'http://localhost:3001/accounts'

  constructor(private http: HttpClient) {}

  getAccounts(): Observable<Account[]> {
    return this.http.get<Account[]>(this.apiUrl);
  }
}
