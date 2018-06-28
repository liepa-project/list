import { ResultSubscriptionService } from './service/result-subscription.service';
import { HttpTranscriptionService, TranscriptionService } from './service/transcription.service';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { UploadComponent } from './upload/upload.component';
import { ResultsComponent } from './results/results.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatTabsModule, MatButtonModule, MatInputModule, MatSnackBarModule, } from '@angular/material';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { FileSizeModule } from 'ngx-filesize';
import { Config } from './config';
import { HttpModule } from '@angular/http';
import { StatusHumanPipe } from './pipes/status-human.pipe';
import { ParamsProviderService } from './service/params-provider.service';

@NgModule({
  declarations: [
    AppComponent,
    UploadComponent,
    ResultsComponent,
    StatusHumanPipe
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpModule,
    BrowserAnimationsModule,
    MatTabsModule, MatButtonModule, MatInputModule, FormsModule,
    MatSnackBarModule,
    MatCardModule, FileSizeModule
  ],
  providers: [Config,
    ParamsProviderService,
    { provide: ResultSubscriptionService, useClass: ResultSubscriptionService },
    { provide: TranscriptionService, useClass: HttpTranscriptionService },  
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
